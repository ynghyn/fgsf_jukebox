module JukeHelper
  LIST_GROUP_ITEM_SUCCESS = 'list-group-item-success'.freeze
  LIST_GROUP_ITEM_INFO = 'list-group-item-info'.freeze

  def is_an_effect?(song)
    song.file ==JukeController::CASSETTE_EFFECT
  end

  def alternate_list_css(css_class)
    if css_class == LIST_GROUP_ITEM_INFO
      LIST_GROUP_ITEM_SUCCESS
    else
      LIST_GROUP_ITEM_INFO
    end
  end

  def playing_now(song)
    if song && is_an_effect?(song)
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

  def previous_songs(mpd)
    songs = []
    if current_song(mpd)
      curr_song_in_queue = mpd_queue(mpd).find { |m| m == current_song(mpd) }
      (0...curr_song_in_queue.pos).each do |i|
        song = mpd_queue(mpd)[i]
        songs << mpd_queue(mpd)[i] unless is_an_effect?(song)
      end
    end
    songs
  end

  def next_songs(mpd)
    songs = []
    if current_song(mpd)
      curr_song_in_queue = mpd_queue(mpd).find { |m| m == current_song(mpd) }
      (curr_song_in_queue.pos+1...mpd_queue(mpd).size).each do |i|
        song = mpd_queue(mpd)[i]
        songs << mpd_queue(mpd)[i] unless is_an_effect?(song)
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

  private

  def current_song(mpd)
    @current_song ||= mpd.current_song
  end

  def mpd_queue(mpd)
    @mpd_queue ||= mpd.queue
  end
end
