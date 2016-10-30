require 'mp3info'

class JukeController < ApplicationController
  include JukeHelper

  skip_before_action :verify_authenticity_token
  before_action :get_or_create_user, only: [:index, :list, :add_song]
  before_action :initialize_mpd

  CASSETTE_EFFECT = 'cassette.wav'.freeze
  BYPASS_CODE = 'bss'.freeze
  MAX_QUEUE_COUNT = 3

  MUSIC_SELECTION_QUERY = 'created_at > ? AND queued = ? AND user_id = \'?\''.freeze
  ROOT_PATH = File.expand_path('~/Music').freeze

  SEMAPHORE = Mutex.new

  def index
    @comments = Comment.all
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

  def song_info
    render partial: 'song_info'
  end

  def coming_up
    render partial: 'coming_up'
  end

  def artwork
    render partial: 'artwork'
  end

  def album_jacket
    render partial: 'album_jacket'
  end

  def feed_comment
    render partial: 'form'
  end

  # API endpoint
  def add_song
    status, msg = if !params[:song_name].present?
      [400, 'You must select a song']
    elsif @current_song && song_already_queued?(params[:song_name])
      record_music_selection(params[:song_name], false)
      [202, '이미 예약목록에 있습니다']
    elsif params[:bypass] != BYPASS_CODE && reached_limit?
      # Limit to 3 songs per 10 minutes
      record_music_selection(params[:song_name], false)
      [429, '10분후에 더 예약 해주세요~']
    elsif params[:bypass] != BYPASS_CODE && !within_open_hour?
      # Only allow queueing during business hour
      record_music_selection(params[:song_name], false)
      [400, 'You can only reserve during operating hours [Sunday 9am-1pm ]']
    elsif @current_song
      record_music_selection(params[:song_name], true)
      add_song_to_mpd(params[:song_name])
      [200, '예약되었습니다!']
    else
      record_music_selection(params[:song_name], true)
      MPD_INSTANCE.clear
      add_song_to_mpd(params[:song_name])
      MPD_INSTANCE.play
      [200, '예약되었습니다!']
    end
    respond_to do |format|
      format.json { render json: {msg: msg, status: status}, status: status }
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
    MPD_INSTANCE.next unless is_an_effect?(@current_song)
    MPD_INSTANCE.next
  end

  # API endpoint
  # Go back twice because of 'cassette' effect queues
  def previous
    return if @current_song.pos == 0
    MPD_INSTANCE.previous unless is_an_effect?(@current_song)
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

  def mp3_image
    image = if params[:file].present?
      Mp3Info.open("#{ROOT_PATH}/#{URI.decode(params[:file])}") do |mp3|
        mp3.tag2.pictures[0][1]
      end
    end
    send_data image, :type => 'image/png', :disposition => 'inline'
  rescue => e
    Rails.logger.error e
    file = File.open(Rails.root.join('app', 'assets', 'images', 'camera.jpg'))
    send_data file.read, :type => 'image/png', :disposition => 'inline'
  end

  def construction
    file = File.open(Rails.root.join('app', 'assets', 'images', 'construction.jpg'))
    send_data file.read, :type => 'image/png', :disposition => 'inline'
  end

  private

  def initialize_mpd
    MPD_INSTANCE.reconnect unless MPD_INSTANCE.connected?
    @current_song = MPD_INSTANCE.current_song
    @music_queue = MPD_INSTANCE.queue
  end

  def choose_effect
    CASSETTE_EFFECT
  end

  def song_already_queued?(file_name)
    @music_queue[@current_song.pos..-1].any? { |song| song.file == file_name }
  end

  def record_music_selection(song_name, queued)
    MusicSelection.create(song: song_name, queued: queued, user_id: @current_user.id)
  end

  def reached_limit?
    MusicSelection.where(MUSIC_SELECTION_QUERY, 10.minutes.ago, true, @current_user.id).count >= 3
  end

  def within_open_hour?
    time_now = Time.now.in_time_zone('Pacific Time (US & Canada)')
    time_now.wday == 0 && # Sunday
      time_now.hour >= 9 && # Between 9AM - 1PM
      time_now.hour < 13
  end

  def add_song_to_mpd(file_name)
    SEMAPHORE.synchronize {
      MPD_INSTANCE.add(choose_effect)
      MPD_INSTANCE.add(file_name)
    }
  end
end
