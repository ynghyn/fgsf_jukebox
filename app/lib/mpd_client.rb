class MPDClient
  CASSETTE_EFFECT = 'cassette.wav'.freeze

  @@queue = []

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

  def self.is_an_effect?(song)
    song.to_h[:file] == CASSETTE_EFFECT
  end

  def self.add_song(song)
    @@queue << song
  end

  def self.dequeue
    start_fresh = current_song.nil?
    unless @@queue.empty?
      Rails.logger.info "Queue: #{@@queue.inspect}"
      song = @@queue.shift
      MPD_INSTANCE.clear if start_fresh
      MPD_INSTANCE.add(CASSETTE_EFFECT)
      MPD_INSTANCE.add(song)
      MPD_INSTANCE.play if start_fresh
    end
  end
end
