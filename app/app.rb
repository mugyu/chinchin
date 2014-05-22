# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'sinatra/base'
require 'sinatra/reloader'
require 'chinchin/game'
require 'chinchin/player'

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

  DEFAULT_POINT = 5

  def point_by(yaku)
    case yaku
    when ChinChin::Result::ARASHI
      DEFAULT_POINT * 3
    when ChinChin::Result::SHIGORO
      DEFAULT_POINT * 2
    when ChinChin::Result::HIFUMI
      DEFAULT_POINT * 2
    else
      DEFAULT_POINT
    end
  end

  # 一勝負する
  #
  # @param game Game Instance
  def play(game)
    results = game.play
    results[:punters].each do |punter_result|
      point = point_by(results[:banker].yaku ? results[:banker].yaku : punter_result.yaku)

      case punter_result.outcome
      when ChinChin::Game::WIN
        game.banker.decrement_tokens point
        punter_result.player.increment_tokens point
      when ChinChin::Game::LOST
        game.banker.increment_tokens point
        punter_result.player.decrement_tokens point
      else
        next
      end
    end
    results
  end

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
