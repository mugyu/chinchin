#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

lib = File.expand_path("../lib", File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "test/unit"
require "chinchin/game"
require "chinchin/players"

# test/unit game class
class TestGame < Test::Unit::TestCase
  # プレイヤ用スタブ
  class StabPlayer
    attr_accessor :name
    def initialize(name)
      @name = name
    end

    def cast
      self
    end
  end

  # プレイヤ以外用スタブ
  class StabNotPlayer; end

  # 結果をコントロールできるチーター
  class StabCheatPlayer
    # 結果クラス
    class Result
      attr_reader :yaku, :point, :dice

      def initialize(yaku, point, dice)
        @yaku = yaku
        @point = point
        @dice = dice
      end
    end

    attr_accessor :name

    def initialize(seed)
      @seed = seed
      @cast_number = 0
    end

    def cast
      yaku, point, dice = @seed[@cast_number]
      @cast_number += 1
      Result.new(yaku, point, dice)
    end
  end

  def setup
    @player1 = StabPlayer.new("player1")
    @player2 = StabPlayer.new("player2")
    @player3 = StabPlayer.new("player3")
  end

  # 参加者が登録したとおりである
  def test_players
    game = ChinChin::Game.new(ChinChin::Players.new(@player1, @player2))
    assert_equal [@player1, @player2], game.players
    assert_not_equal [@player1, @player3], game.players

    game = ChinChin::Game.new(
      ChinChin::Players.new(@player1, @player2, @player3))
    assert_equal [@player1, @player2, @player3], game.players
  end

  # 親(Banker)の設定と参照
  def test_set_banker
    players = ChinChin::Players.new(@player1, @player2, @player3)

    game = ChinChin::Game.new(players)
    game.banker = @player2
    assert_same @player2, game.banker
  end

  # プレイヤを参加者一覧に追加する
  def test_add_player
    players = ChinChin::Players.new(@player1)

    game = ChinChin::Game.new(players)
    game.add_player(@player2)
    game.add_player(@player3)
    assert_equal [@player1, @player2, @player3], game.players
  end

  # プレイヤを参加者一覧から除外する
  def test_remove_player
    players = ChinChin::Players.new(@player1, @player2, @player3)

    game = ChinChin::Game.new(players)
    game.remove_player(@player1)
    game.remove_player(@player3)
    assert_equal [@player2], game.players
  end

  # 役作りの結果を検証(賽を投じた結果では無い)
  def test_make
    # 目なしの場合
    nothing_and_0 = StabCheatPlayer.new([
      [nil, 0, [1, 4, 5]],
      [nil, 0, [2, 4, 5]],
      [nil, 0, [3, 4, 5]]
    ])
    game = ChinChin::Game.new(ChinChin::Players.new(nothing_and_0))
    result = game.make(nothing_and_0)
    assert_equal nothing_and_0, result.player
    assert_equal nil, result.yaku
    assert_equal 0, result.point
    assert_equal [[1, 4, 5], [2, 4, 5], [3, 4, 5]], result.dice

    # 一投目の出目が1, 後続にそれを上回る出目2 が出現
    nothing_and_2 = StabCheatPlayer.new([
      [nil, 1, [1, 2, 2]],
      [nil, 2, [2, 4, 4]],
      [nil, 0, [1, 3, 6]]
    ])
    game = ChinChin::Game.new(ChinChin::Players.new(nothing_and_2))
    result = game.make(nothing_and_2)
    assert_equal nothing_and_2, result.player
    assert_equal nil, result.yaku
    assert_equal 2, result.point
    assert_equal [[1, 2, 2], [2, 4, 4], [1, 3, 6]], result.dice

    # 一投目で出目が5、後続は一投目より低い目
    nothing_and_5 = StabCheatPlayer.new([
      [nil, 5, [4, 4, 5]],
      [nil, 4, [2, 4, 2]],
      [nil, 3, [3, 1, 1]]
    ])
    game = ChinChin::Game.new(ChinChin::Players.new(nothing_and_5))
    result = game.make(nothing_and_5)
    assert_equal nothing_and_5, result.player
    assert_equal nil, result.yaku
    assert_equal 5, result.point
    assert_equal [[4, 4, 5], [2, 4, 2], [3, 1, 1]], result.dice

    # 二投目でヒフミ
    # 役が出来た時点で決する為、二投で終わり
    hifumi = StabCheatPlayer.new([
      [nil, 1, [6, 6, 1]],
      [:HIFUMI, -1, [1, 2, 3]]
    ])
    game = ChinChin::Game.new(ChinChin::Players.new(hifumi))
    result = game.make(hifumi)
    assert_equal hifumi, result.player
    assert_equal :HIFUMI, result.yaku
    assert_equal(-1, result.point)
    assert_equal [[6, 6, 1], [1, 2, 3]], result.dice
  end

  # 親の出目は5
  # 子の目は、
  # - 出目が3の負け
  # - 役がシゴロの勝ち
  # - 出目が5の引き分け
  def test_play
    banker = StabCheatPlayer.new([
      [nil, 5, [4, 4, 5]],
      [nil, 4, [2, 4, 2]],
      [nil, 3, [3, 1, 1]]
    ])
    punter1 = StabCheatPlayer.new([
      [nil, 1, [1, 1, 2]],
      [nil, 0, [3, 4, 2]],
      [nil, 3, [6, 6, 3]]
    ])
    punter2 = StabCheatPlayer.new([
      [:SIGORO, 10, [6, 4, 5]]
    ])
    punter3 = StabCheatPlayer.new([
      [nil, 4, [2, 4, 2]],
      [nil, 3, [3, 1, 1]],
      [nil, 5, [4, 4, 5]]
    ])
    players = ChinChin::Players.new(banker, punter1, punter2, punter3)

    game = ChinChin::Game.new(players)
    game.banker = banker
    results = game.play

    assert_equal nil,     results[:banker].yaku
    assert_equal 5,       results[:banker].point

    assert_equal :Lost,   results[:punters][0].outcome
    assert_equal nil,     results[:punters][0].yaku
    assert_equal 3,       results[:punters][0].point

    assert_equal :Win,    results[:punters][1].outcome
    assert_equal :SIGORO, results[:punters][1].yaku
    assert_equal 10,      results[:punters][1].point

    assert_equal :Draw,   results[:punters][2].outcome
    assert_equal nil,     results[:punters][2].yaku
    assert_equal 5,       results[:punters][2].point
  end

  # 親の役がアラシなので子は無条件で負け
  # 子の結果が無し
  def test_play_banker_with_arashi
    banker = StabCheatPlayer.new([
      [:ARASHI, 11, [1, 1, 1]]
    ])
    punter1 = StabCheatPlayer.new([
      [nil, 5, [4, 4, 5]],
      [nil, 4, [2, 4, 2]],
      [nil, 3, [3, 1, 1]]
    ])
    punter2 = StabCheatPlayer.new([
      [nil, 5, [4, 4, 5]],
      [nil, 4, [2, 4, 2]],
      [nil, 3, [3, 1, 1]]
    ])
    players = ChinChin::Players.new(banker, punter1, punter2)

    game = ChinChin::Game.new(players)
    game.banker = banker
    results = game.play

    assert_equal :ARASHI, results[:banker].yaku
    assert_equal 11,      results[:banker].point

    assert_equal :Lost,   results[:punters][0].outcome
    assert_equal nil,     results[:punters][0].yaku
    assert_equal nil,     results[:punters][0].point
    assert_equal :Lost,   results[:punters][1].outcome
    assert_equal nil,     results[:punters][1].yaku
    assert_equal nil,     results[:punters][1].point
  end
end
