# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'sinatra/base'
require 'chinchin/game'
require 'chinchin/player'

class App < Sinatra::Base

  set :public_folder, File.expand_path(File.join(root, "..", "public"))

  configure :development do
    puts "Development mode."
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

  # ダイスのimgタグを返す
  #
  # @param pips 出目
  def dice_image(pips)
    %Q|<image src="img/dice16-#{pips}.gif" />|
  end

  # 複数のダイスのimgタグを返す
  #
  # @param dice 複数の出目
  def dice_images(dice)
    dice.map{|pips|dice_image(pips)}
  end

  def outcome_icon(outcome)
    case outcome
    when ChinChin::Game::WIN
      %Q|<img src="img/win.gif" />|
    when ChinChin::Game::LOST
      %Q|<img src="img/lost.gif" />|
    when ChinChin::Game::DRAW
      ""
    else
      ""
    end
  end

  # プレイ結果の表示
  #
  # @param result プレイ結果
  # @param role   親と子の識別 :banker 親, :punter 子
  def play_result(result, role)
    erb :play_result, locals: {
      name: result.player.name,
      outcome: result.outcome,
      point: result.yaku ? result.yaku : result.point,
      tokens: result.player.tokens,
      dice_set: result.dice
    }
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
