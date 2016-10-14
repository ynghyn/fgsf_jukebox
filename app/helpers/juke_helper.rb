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
      song.file.split('/').last
    else
      'choose thy song from /juke/list'
    end
  end
end
