class MPDClient
  CASSETTE_EFFECT = 'cassette.wav'.freeze

  @@queue = []
  @@worker_mutex = Mutex.new
  @@dequeue_mutex = Mutex.new
  @@worker_thread = nil

  def self.current_song
    # Caching will help unload server calls to MPD
    Rails.cache.fetch(:current_song, expires_in: 1.seconds) do
      MPD_INSTANCE.current_song && MPD_INSTANCE.current_song.to_h
    end
  end

  def self.playlist
    # Caching will help unload server calls to MPD
    Rails.cache.fetch(:playlist, expires_in: 1.seconds) do
      Array(MPD_INSTANCE.queue).map(&:to_h)
    end
  end

  def self.songs
    # Library of songs aren't likely to change often.
    # If you want to reload music library, just restart the server.
    @@songs ||= MPD_INSTANCE.songs.select { |song| !is_an_effect?(song) }
  end

  def self.song_already_queued?(file_name)
    @@queue.include?(file_name) ||
      (
        MPDClient.current_song &&
        MPDClient.playlist[MPDClient.current_song[:pos]..-1].any? { |song| song[:file] == file_name }
      )
  end

  def self.is_an_effect?(song)
    song.to_h[:file] == CASSETTE_EFFECT
  end

  def self.add_song(song)
    ensure_worker_running
    @@queue << song
  end

  def self.dequeue
    # Mutex ensures that we only have one instance of dequeue at a time
    @@dequeue_mutex.synchronize do
      unless @@queue.empty?
        Rails.logger.info "Queue: #{@@queue.inspect}"
        play_from_begging = current_song.nil?
        song = @@queue.shift
        MPD_INSTANCE.clear if play_from_begging
        MPD_INSTANCE.add(CASSETTE_EFFECT)
        MPD_INSTANCE.add(song)
        MPD_INSTANCE.play if play_from_begging
      end
    end
  end

  private

  def self.ensure_worker_running
    return if worker_running?

    # Mutex: make sure only one Thread runs at a time.
    @@worker_mutex.synchronize do
      return if worker_running?
      start_worker
    end
  end

  def self.start_worker
    # A never-ending thread that dequeues music every 2 seconds
    @@worker_thread = Thread.new do
      while true
        MPDClient.dequeue
        sleep 2
      end
    end
  end

  def self.worker_running?
    @@worker_thread && @@worker_thread.alive?
  end
end
