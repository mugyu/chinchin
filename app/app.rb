# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
$LOAD_PATH.unshift File.dirname(__FILE__)
require "sinatra/base"
require "sinatra/reloader"

require "chinchin/player"

require "views/play_result"
require "models/playing_game"

# Game Object 生成
module GameBuilder
  def self.included(base)
    base.extend ClassMethods
  end

  # extend class methods
  module ClassMethods
    attr_accessor :result

    def new_game
      banker  = ChinChin::Player.new("Alan Smithee")
      punter1 = ChinChin::Player.new("John Doe")
      punter2 = ChinChin::Player.new("Richard Roe")
      punter3 = ChinChin::Player.new("Mario Rossi")
      @game = Models::PlayingGame.new(
        { value: 3, player: banker },
        200,
        0,
        banker, punter1, punter2, punter3
      )
      @game.banker = banker
      @game
    end

    def game
      @game ||= new_game
    end
  end

  # syntax suger for `self.class.game`
  def game
    self.class.game
  end

  # syntax suger for `self.class.new_game`
  def new_game
    self.class.new_game
  end

  # syntax suger for `self.class.result`
  def result
    self.class.result
  end

  # syntax suger for `self.class.result=(result)`
  def result=(result)
    self.class.result = result
  end
end

# チンチロリン アプリケーション
class App < Sinatra::Base
  set :public_folder, File.expand_path(File.join(root, "..", "public"))

  configure :development do
    puts "Development mode."
    register Sinatra::Reloader
  end

  configure :production do
    puts "Production mode."
  end

  # 別名path
  def alias_path(path)
    call env.merge("PATH_INFO" => path)
  end

  TITLE = :ChinChin

  helpers Views::PlayResult
  helpers GameBuilder

  get "/" do
    new_game
    erb :index
  end

  get "/play" do
    if game.counter_limit_reached?
      erb :finish, locals: { players: game.players }
    else
      self.result = game.play
      if game.tokens_is_upper_limit_reahed? ||
         game.tokens_is_lower_limit_reahed?
        erb :finish, locals: { players: game.players }
      else
        erb :play, locals: { game_results: result }
      end
    end
  end
end
