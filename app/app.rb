# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'sinatra/base'
require 'sinatra/reloader'

require 'chinchin/game'
require 'chinchin/player'

require 'views/play_result'
require 'models/playing'

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
  helpers Models::Playing

  get "/" do

    @title = TITLE

    banker  = ChinChin::Player.new("banker")
    punter1 = ChinChin::Player.new("punter1")
    punter2 = ChinChin::Player.new("punter2")
    punter3 = ChinChin::Player.new("punter3")
    game = ChinChin::Game.new(banker, punter1, punter2, punter3)
    game.banker = banker

    erb :index, :locals => {game_results: play(game)}
  end

  get "/play" do
    alias_path "/"
  end
end
