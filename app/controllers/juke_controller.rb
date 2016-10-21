class JukeController < ApplicationController
  include JukeHelper

  skip_before_action :verify_authenticity_token
  before_action :get_or_create_user, only: [:index, :list, :add_song]
  before_action :initialize_mpd

  CASSETTE_EFFECT = 'cassette.wav'.freeze
  CASSETTE2_EFFECT = 'cassette2.mp3'.freeze
  CD_PLAYER_EFFECT = 'cdplayer.wav'.freeze
  ALL_EFFECTS = [CASSETTE_EFFECT, CD_PLAYER_EFFECT, CASSETTE2_EFFECT].freeze

  BYPASS_CODE = 'bss'.freeze
  MAX_QUEUE_COUNT = 3

  def index
  end

  def list
    @songs = MPD_INSTANCE.songs.select { |song| !is_an_effect?(song) }
  end

  # partial endpoint
  def playing_now
    render partial: 'playing_now'
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
    elsif @current_song && song_already_queued?(params[:song_name])
      record_and_update_cookie(params[:song_name], false)
      [200, '이미 예약목록에 있습니다']
    elsif cookies['queue_count'].to_i >= MAX_QUEUE_COUNT && params[:bypass] != BYPASS_CODE
      # Limit to 3 songs per 10 minutes
      record_and_update_cookie(params[:song_name], false)
      [429, 'Try again in 10 minutes.']
    elsif @current_song
      record_and_update_cookie(params[:song_name], true)
      #MPD_INSTANCE.add(choose_effect)
      MPD_INSTANCE.add(params[:song_name])
      MPD_INSTANCE.play if MPD_INSTANCE.stopped?
      [200, '예약되었습니다!']
    else
      record_and_update_cookie(params[:song_name], true)
      MPD_INSTANCE.clear
      #MPD_INSTANCE.add(choose_effect)
      MPD_INSTANCE.add(params[:song_name])
      MPD_INSTANCE.play
      [200, '예약되었습니다!']
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
  def pause_or_play
    if MPD_INSTANCE.playing?
      MPD_INSTANCE.pause = true
    elsif @music_queue.present? && (MPD_INSTANCE.paused? || MPD_INSTANCE.stopped?)
      MPD_INSTANCE.play
    end
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
    return if @current_song.pos == 0
    MPD_INSTANCE.previous
    MPD_INSTANCE.previous
  end

  # API endpoint
  def play
    MPD_INSTANCE.play if @music_queue.present? && (MPD_INSTANCE.paused? || MPD_INSTANCE.stopped?)
  end

  # API endpoint
  def clear
    MPD_INSTANCE.clear
  end

  private

  def initialize_mpd
    MPD_INSTANCE.reconnect unless MPD_INSTANCE.connected?
    @current_song = MPD_INSTANCE.current_song
    @music_queue = MPD_INSTANCE.queue
  end

  def choose_effect
    ALL_EFFECTS[rand(3)]
  end

  def song_already_queued?(file_name)
    @music_queue[@current_song.pos..-1].any? { |song| song.file == file_name }
  end

  def record_and_update_cookie(song_name, queued)
    MusicSelection.create(song: song_name, queued: queued, user_id: @current_user.id)
    if queued
      count = cookies['queue_count'].to_i
      response.set_cookie 'queue_count', { value: count + 1, expires: 10.minutes.from_now }
    end
  end
end
