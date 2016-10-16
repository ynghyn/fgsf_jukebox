require 'ruby-mpd'

class JukeController < ApplicationController
  CASSETTE_EFFECT = 'cassette.wav'.freeze

  def index
  end

  def playing_now
    render partial: 'playing_now'
  end

  def list
    @songs = MPD_INSTANCE.songs.select { |song| !song.file.include?(CASSETTE_EFFECT) }
  end

  def add_song
    if !params[:song_name].present?
      flash.alert = 'You must select a song'
    elsif MPD_INSTANCE.current_song
      MPD_INSTANCE.add(CASSETTE_EFFECT)
      MPD_INSTANCE.add(params[:song_name])
      MPD_INSTANCE.play if MPD_INSTANCE.stopped?
    else
      MPD_INSTANCE.clear
      MPD_INSTANCE.add(CASSETTE_EFFECT)
      MPD_INSTANCE.add(params[:song_name])
      MPD_INSTANCE.play
    end
    respond_to do |format|
      format.json {}
    end
  end

  def pause
    MPD_INSTANCE.pause = true if MPD_INSTANCE.playing?
    redirect_to juke_index_path
  end

  def stop
    MPD_INSTANCE.stop if MPD_INSTANCE.playing?
    redirect_to juke_index_path
  end

  def next
    MPD_INSTANCE.next
    redirect_to juke_index_path
  end

  # Go back twice because of 'cassette' effect queues
  def previous
    MPD_INSTANCE.previous
    MPD_INSTANCE.previous
    redirect_to juke_index_path
  end

  def play
    MPD_INSTANCE.play if MPD_INSTANCE.queue.present? && (MPD_INSTANCE.paused? || MPD_INSTANCE.stopped?)
    redirect_to juke_index_path
  end

  def clear
    MPD_INSTANCE.clear
    redirect_to juke_index_path
  end
end
