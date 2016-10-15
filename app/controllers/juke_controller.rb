require 'ruby-mpd'

class JukeController < ApplicationController
  before_action :initialize_mpd

  CASSETTE_EFFECT = 'cassette.wav'.freeze

  def index
  end

  def playing_now
    render partial: 'playing_now'
  end

  def list
    @songs = @mpd.songs.select { |song| !song.file.include?(CASSETTE_EFFECT) }
    @mpd.disconnect
  end

  def add_song
    if !params[:song_name].present?
      flash.alert = 'You must select a song'
    elsif @mpd.current_song
      @mpd.add(CASSETTE_EFFECT)
      @mpd.add(params[:song_name])
      @mpd.play if @mpd.stopped?
    else
      @mpd.clear
      @mpd.add(CASSETTE_EFFECT)
      @mpd.add(params[:song_name])
      @mpd.play
    end
    @mpd.disconnect
    redirect_to juke_list_path
  end

  def pause
    @mpd.pause = true if @mpd.playing?
    @mpd.disconnect
    redirect_to juke_index_path
  end

  def stop
    @mpd.stop if @mpd.playing?
    @mpd.disconnect
    redirect_to juke_index_path
  end

  def next
    @mpd.next
    @mpd.disconnect
    redirect_to juke_index_path
  end

  # Go back twice because of 'cassette' effect queues
  def previous
    @mpd.previous
    @mpd.previous
    @mpd.disconnect
    redirect_to juke_index_path
  end

  def play
    @mpd.play if @mpd.queue.present? && (@mpd.paused? || @mpd.stopped?)
    @mpd.disconnect
    redirect_to juke_index_path
  end

  def clear
    @mpd.clear unless @mpd.queue.present?
    @mpd.disconnect
    redirect_to juke_index_path
  end

  private

  def initialize_mpd
    @mpd = MPD.new
    @mpd.connect
    @mpd.update
  end
end
