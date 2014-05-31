# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'sinatra/base'
require 'sinatra/reloader'

require 'chinchin/player'

require 'views/play_result'
require 'models/playing_game'

module GameBuilder
  def self.new_game
    banker  = ChinChin::Player.new("banker")
    punter1 = ChinChin::Player.new("punter1")
    punter2 = ChinChin::Player.new("punter2")
    punter3 = ChinChin::Player.new("punter3")
    @game = Models::PlayingGame.new(banker, punter1, punter2, punter3)
    @game.banker = banker
    @game
  end

  def self.game
    @game ||= self.class.new_game
  end

  # syntax suger for `self.class.game`
  def game
    self.class.game
  end

  # syntax suger for `self.class.new_game`
  def new_game
    self.class.new_game
  end
end

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

  helpers Views::Play_result
  helpers GameBuilder

  get "/" do
    @title = TITLE
    erb :index, :locals => {game_results: new_game.play}
  end

  get "/play" do
    @title = TITLE
    erb :index, :locals => {game_results: game.play}
  end
end
