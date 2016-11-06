module JukeHelper
  def playing_now(song)
    if song && MPDClient.is_an_effect?(song)
      'changing tape..'
    elsif song
      hash = song.to_h
      title = hash[:title] || normalize_file_name(song.file)
      artist = hash[:artist]
      album = hash[:album]
      "#{title}<br/>#{artist}<br/>#{album}".html_safe
    else
      'Please choose a song.'
    end
  end

  def previous_songs
    songs = []
    if MPDClient.current_song
      curr_song_in_queue = MPDClient.playlist.find { |m| m == MPDClient.current_song }
      (0...curr_song_in_queue[:pos]).each do |i|
        song = MPDClient.playlist[i]
        songs << MPDClient.playlist[i] unless MPDClient.is_an_effect?(song)
      end
    end
    songs
  end

  def next_songs
    songs = []
    if MPDClient.current_song
      curr_song_in_queue = MPDClient.playlist.find { |m| m == MPDClient.current_song }
      (curr_song_in_queue[:pos]+1...MPDClient.playlist.size).each do |i|
        song = MPDClient.playlist[i]
        songs << MPDClient.playlist[i] unless MPDClient.is_an_effect?(song)
      end
    end
    songs
  end

  def normalize_file_name(file_name)
    file_name.split('/').last.split('.')[-2]
  end

  def artist(song)
    song.to_h[:artist]
  end

  def title(song)
    song.to_h[:title] || normalize_file_name(song.file)
  end

  def album(song)
    song.to_h[:album]
  end
end
