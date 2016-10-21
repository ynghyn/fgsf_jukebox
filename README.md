# FGSF Jukebox
A jukebox where music plays on a central hub with ability for users to DJ the songs to be played.

### Environments
- **Ruby version**: 2.3.1
- **Rails version**: 5.0.0.1

### System dependencies
1) Install Music Player Daemon which is a daemon server that enables you to control song library, playlists, and control of audio. Rails will communicate with MPD as a client to enqueue and play music.
- Link to complete guide [Music Player Daemon](https://www.musicpd.org)
- A short 1-page guide [Link](http://crunchbang.org/forums/viewtopic.php?id=17386) 
2) [ruby-mpd](https://github.com/archSeer/ruby-mpd) - A Ruby client gem to communicate with **mpd** server.
3) [FreeSound](https://www.freesound.org/) - a few sound effects

## Configuration
- Follow this[1-page guide](http://crunchbang.org/forums/viewtopic.php?id=17386) to get your MPD server up and running
- If MPD has run for long time, its response time begins to slow. To prevent yourself from running into latency issue, avoid usage of daemon but  manually start your mpd server each time.
```
// By default, MPD runs on port 6600. Kill MPD and run as non-daemon.
$ mpd --kill
$ mpd --no-daemon --stdout --verbose

// Hint if processes are still lingering around, kill them all
$ lsof -i:6600
$ kill -9 PRCESSID
$ ps aux | grep mpd
$ kill -9 PROCESSID
```
- Required sound effects are placed under `misc/`. Copy them onto your music dierectory.

### Database
`Coming soon.`

### TODO
- [ruby-mp3info](https://github.com/moumar/ruby-mp3info) - MP3 tag info collector

>######By [Yonghyun Kim](https://github.com/ynghyn), [Jiwoo Park](https://github.com/jparkSF), [Hojin Lee](https://github.com/hlee0213)  