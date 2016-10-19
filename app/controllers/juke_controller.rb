class JukeController < ApplicationController
  include JukeHelper

  before_action :initialize_mpd

  CASSETTE_EFFECT = 'cassette.wav'.freeze
  CD_PLAYER_EFFECT = 'cdplayer.wav'.freeze
  LP_NOISE_EFFECT = 'lpnoise.wav'.freeze
  ALL_EFFECTS = [CASSETTE_EFFECT, CD_PLAYER_EFFECT, LP_NOISE_EFFECT].freeze

  def index
  end

  def list
    @songs = MPD_INSTANCE.songs.select { |song| !is_an_effect?(song) }
  end

  # partial endpoint
  def playing_now
    render partial: 'playing_now'
  end

  def time
    render partial: 'time'
  end

  def title
    render partial: 'title'
  end

  def play_button
    render partial: 'play_button'
  end

  # API endpoint
  def add_song
    status, msg = if !params[:song_name].present?
      [400, 'You must select a song']
    elsif MPD_INSTANCE.current_song
      MPD_INSTANCE.add(choose_effect)
      MPD_INSTANCE.add(params[:song_name])
      MPD_INSTANCE.play if MPD_INSTANCE.stopped?
      [200, nil]
    else
      MPD_INSTANCE.clear
      MPD_INSTANCE.add(choose_effect)
      MPD_INSTANCE.add(params[:song_name])
      MPD_INSTANCE.play
      [200, nil]
    end
    respond_to do |format|
      format.json { render json: {msg: msg}, status: status }
    end
  end

  # API endpoint
  def pause
    MPD_INSTANCE.pause = true if MPD_INSTANCE.playing?
  end

  # API endpoint
  def stop
    MPD_INSTANCE.stop if MPD_INSTANCE.playing?
  end

  # API endpoint
  def next
    MPD_INSTANCE.next
    MPD_INSTANCE.next
  end

  # API endpoint
  # Go back twice because of 'cassette' effect queues
  def previous
    MPD_INSTANCE.previous
    MPD_INSTANCE.previous
  end

  # API endpoint
  def play
    MPD_INSTANCE.play if MPD_INSTANCE.queue.present? && (MPD_INSTANCE.paused? || MPD_INSTANCE.stopped?)
  end

  # API endpoint
  def clear
    MPD_INSTANCE.clear
  end

  private

  def initialize_mpd
    MPD_INSTANCE.reconnect unless MPD_INSTANCE.connected?
  end

  def choose_effect
    ALL_EFFECTS[rand(3)]
  end
end
