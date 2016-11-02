require 'ruby-mpd'

MPD_INSTANCE = MPD.new
MPD_INSTANCE.connect
MPD_INSTANCE.update

# Runs a never-ending thread that enqueues music to MPD every 2 seconds
Thread.new do
  while true do
    MPDClient.dequeue
    sleep 2
  end
end