module JukeHelper
  LIST_GROUP_ITEM_SUCCESS = 'list-group-item-success'.freeze
  LIST_GROUP_ITEM_INFO = 'list-group-item-info'.freeze

  def is_an_effect?(song)
    JukeController::ALL_EFFECTS.any? { |effect| song.file.include?(effect) }
  end

  def alternate_list_css(css_class)
    if css_class == LIST_GROUP_ITEM_INFO
      LIST_GROUP_ITEM_SUCCESS
    else
      LIST_GROUP_ITEM_INFO
    end
  end

  def playing_now(song)
    if song.try(:file) && is_an_effect?(song)
      'changing tape..'
    elsif song.try(:file)
      normalize_file_name(song.file)
    else
      'choose thy song from /juke/list'
    end
  end

  def previous_songs(mpd)
    if mpd_queue(mpd).present? && current_song(mpd)
      curr_song_in_queue = mpd_queue(mpd).find { |m| m == current_song(mpd) }
      item_remaining = curr_song_in_queue.pos - 3
      more_songs = if item_remaining > 0
        "...+#{item_remaining}"
      end
      [
        more_songs,
        get_song_in_pos(mpd, curr_song_in_queue, -3),
        get_song_in_pos(mpd, curr_song_in_queue, -2),
        get_song_in_pos(mpd, curr_song_in_queue, -1),
      ].compact
    else
      []
    end
    # if mpd_queue(mpd).present? && current_song(mpd)
    #   variable = if is_an_effect?(current_song(mpd))
    #     1
    #   else
    #     0
    #   end
    #   curr_song_in_queue = mpd_queue(mpd).find { |m| m == current_song(mpd) }
    #   item_remaining = curr_song_in_queue.pos - 6 + variable
    #   more_songs = if item_remaining/2 > 0
    #     "...+#{item_remaining/2}"
    #   end
    #   [
    #     more_songs,
    #     get_song_in_pos(mpd, curr_song_in_queue, -6+variable),
    #     get_song_in_pos(mpd, curr_song_in_queue, -4+variable),
    #     get_song_in_pos(mpd, curr_song_in_queue, -2+variable),
    #   ].compact
    # else
    #   []
    # end
  end

  def next_songs(mpd)
    if mpd_queue(mpd).present? && current_song(mpd)
      curr_song_in_queue = mpd_queue(mpd).find { |m| m == current_song(mpd) }
      item_remaining = mpd_queue(mpd).size - curr_song_in_queue.pos - 4
      more_songs = if item_remaining > 0
        "...+#{item_remaining}"
      end
      [
        get_song_in_pos(mpd, curr_song_in_queue, 1),
        get_song_in_pos(mpd, curr_song_in_queue, 2),
        get_song_in_pos(mpd, curr_song_in_queue, 3),
        more_songs,
      ].compact
    else
      []
    end
    # if mpd_queue(mpd).present? && current_song(mpd)
    #   variable = if is_an_effect?(current_song(mpd))
    #     -1
    #   else
    #     0
    #   end
    #   curr_song_in_queue = mpd_queue(mpd).find { |m| m == current_song(mpd) }
    #   item_remaining = mpd_queue(mpd).size - curr_song_in_queue.pos - 6 - variable
    #   more_songs = if item_remaining/2 > 0
    #     "...+#{item_remaining/2}"
    #   end
    #   [
    #     get_song_in_pos(mpd, curr_song_in_queue, 2+variable),
    #     get_song_in_pos(mpd, curr_song_in_queue, 4+variable),
    #     get_song_in_pos(mpd, curr_song_in_queue, 6+variable),
    #     more_songs,
    #   ].compact
    # else
    #   []
    # end
  end

  def normalize_file_name(file_name)
    file_name.split('/').last.split('.')[-2]
  end

  private

  def get_song_in_pos(mpd, song, pos)
    if song.pos + pos >= 0
      song_in_pos = mpd_queue(mpd)[song.pos + pos]
      song_in_pos && normalize_file_name(song_in_pos.file)
    end
  end

  def current_song(mpd)
    @current_song ||= mpd.current_song
  end

  def mpd_queue(mpd)
    @mpd_queue ||= mpd.queue
  end
end
