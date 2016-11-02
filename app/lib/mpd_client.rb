class MPDClient
  def self.current_song
    @@current_song
  end

  def self.current_song=(song)
    @@current_song = song
  end
end