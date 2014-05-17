# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'sinatra/base'
require 'chinchin/game'
require 'chinchin/player'

require 'stringio'

class App < Sinatra::Base

  set :public_folder, File.expand_path(File.join(root, "..", "public"))

  configure :development do
    puts "Development mode."
  end

  configure :production do
    puts "Production mode."
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
    "<image src='img/dice16-#{pips}.gif' />"
  end

  # 複数のダイスのimgタグを返す
  #
  # @param dice 複数の出目
  def dice_images(dice)
    dice.map{|pips|dice_image(pips)}
  end

  def view(result)
    if result.point
      head = result.outcome ? result.outcome : "Banker"
      point = result.yaku ? result.yaku : result.point
      dice_images_set = result.dice.map{|dice|dice_images(dice).join}

      printf "%3d %6s: #{result.player.name} [ #{point} ] #{dice_images_set.join("&nbsp;")}\n", result.player.tokens, head
    else
      printf "%3d %6s: #{result.player.name}\n", result.player.tokens, result.outcome
    end
  end

  def play(game)
    results = game.play
    results[:punters].each do |result|
      point = point_by(results[:banker].yaku ? results[:banker].yaku : result.yaku)

      case result.outcome
      when ChinChin::Game::WIN
        game.banker.decrement_tokens   point
        result.player.increment_tokens point
      when ChinChin::Game::LOST
        game.banker.increment_tokens   point
        result.player.decrement_tokens point
      else
      end
      view(result)
    end
    puts "-------"
    view(results[:banker])
  end

  get "/" do
    @title = TITLE

    banker  = ChinChin::Player.new("banker")
    punter1 = ChinChin::Player.new("punter1")
    punter2 = ChinChin::Player.new("punter2")
    punter3 = ChinChin::Player.new("punter3")
    game = ChinChin::Game.new(banker, punter1, punter2, punter3)
    game.banker = banker

    buff = StringIO.new
    $stdout = buff
    play(game)
    $stdout = STDOUT

    @result = buff.string

    erb :index
  end
end
