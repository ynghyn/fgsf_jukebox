require 'ruby-mpd'

MPD_INSTANCE = MPD.new
MPD_INSTANCE .connect
MPD_INSTANCE .update
