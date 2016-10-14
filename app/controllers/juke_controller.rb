require 'ruby-mpd'

class JukeController < ApplicationController
  before_action :initialize_mpd

  def index
  end

  def list
    @songs = @mpd.songs
    @mpd.disconnect
  end

  def add_song
    if !params[:song_name].present?
      flash.alert = 'You must select a song'
    elsif @mpd.current_song
      @mpd.add(params[:song_name])
      @mpd.play if @mpd.stopped?
    else
      @mpd.clear
      @mpd.add(params[:song_name])
      @mpd.play
    end
    @mpd.disconnect
    redirect_to juke_list_path
  end

  def stop
    @mpd.stop
    @mpd.disconnect
    redirect_to juke_index_path
  end

  def play
    @mpd.play
    @mpd.disconnect
    redirect_to juke_index_path
  end

  def clear
    @mpd.clear
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
