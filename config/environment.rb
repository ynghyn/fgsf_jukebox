# Load the Rails application.
require_relative 'application'

require 'ruby-mpd'

MPD_INSTANCE = MPD.new
MPD_INSTANCE.connect
MPD_INSTANCE.update

# Initialize the Rails application.
Rails.application.initialize!
