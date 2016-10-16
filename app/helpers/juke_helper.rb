module JukeHelper
  LIST_GROUP_ITEM_SUCCESS = 'list-group-item-success'.freeze
  LIST_GROUP_ITEM_INFO = 'list-group-item-info'.freeze

  def alternate_list_css(css_class)
    if css_class == LIST_GROUP_ITEM_INFO
      LIST_GROUP_ITEM_SUCCESS
    else
      LIST_GROUP_ITEM_INFO
    end
  end

  def playing_now(song)
    if song.try(:file) && song.file.include?(JukeController::CASSETTE_EFFECT)
      'changing tape..'
    elsif song.try(:file)
      normalize_file_name(song.file)
    else
      'choose thy song from /juke/list'
    end
  end

  def previous_songs(mpd)
    if mpd.queue.present? && mpd.current_song
      variable = if mpd.current_song.file.include?(JukeController::CASSETTE_EFFECT)
        1
      else
        0
      end
      curr_song_in_queue = mpd.queue.find { |m| m == mpd.current_song }
      item_remaining = curr_song_in_queue.pos - 6 + variable
      more_songs = if item_remaining/2 > 0
        "...+#{item_remaining/2}"
      end
      [
        more_songs,
        get_song_in_pos(mpd, curr_song_in_queue, -6+variable),
        get_song_in_pos(mpd, curr_song_in_queue, -4+variable),
        get_song_in_pos(mpd, curr_song_in_queue, -2+variable),
      ].compact
    else
      []
    end
  end

  def next_songs(mpd)
    if mpd.queue.present? && mpd.current_song
      variable = if mpd.current_song.file.include?(JukeController::CASSETTE_EFFECT)
        -1
      else
        0
      end
      curr_song_in_queue = mpd.queue.find { |m| m == mpd.current_song }
      item_remaining = mpd.queue.size - curr_song_in_queue.pos - 6 - variable
      more_songs = if item_remaining/2 > 0
        "...+#{item_remaining/2}"
      end
      [
        get_song_in_pos(mpd, curr_song_in_queue, 2+variable),
        get_song_in_pos(mpd, curr_song_in_queue, 4+variable),
        get_song_in_pos(mpd, curr_song_in_queue, 6+variable),
        more_songs,
      ].compact
    else
      []
    end
  end

  def normalize_file_name(file_name)
    file_name.split('/').last.split('.')[-2]
  end

  private

  def get_song_in_pos(mpd, song, pos)
    if song.pos + pos >= 0
      song_in_pos = mpd.queue[song.pos + pos]
      song_in_pos && normalize_file_name(song_in_pos.file)
    end
  end
end
