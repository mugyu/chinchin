#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

lib = File.expand_path("../lib", File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "test/unit"
require "chinchin/players"

# test/unit players class
class TestPlayers < Test::Unit::TestCase
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

  def setup
    @player1 = StabPlayer.new("player1")
    @player2 = StabPlayer.new("player2")
    @player3 = StabPlayer.new("player3")
  end

  # 参加者が登録したとおりである
  def test_players
    players = ChinChin::Players.new(@player1, @player2)
    assert_equal [@player1, @player2], players.to_a
    assert_not_equal [@player1, @player3], players.to_a

    players = ChinChin::Players.new([@player1, @player2, @player3])
    assert_equal [@player1, @player2, @player3], players.to_a
  end

  # castメソッドを持たないモノを参加者させようとした場合、例外が発生
  def test_not_player_object_error
    not_player = StabNotPlayer.new

    # exception class
    assert_raise ChinChin::Players::NotPlayerError do
      ChinChin::Players.new(@player1, @player2, not_player)
    end

    # exception message
    assert_raise "This is not player object. cast method is necessary." do
      ChinChin::Players.new(@player1, @player2, not_player)
    end
  end

  # 親(Banker)の設定と参照
  def test_set_banker
    players = ChinChin::Players.new(@player1, @player2, @player3)
    players.banker = @player2
    assert_same @player2, players.banker
    assert_not_equal @player1, players.banker
    assert_not_equal @player3, players.banker

    # 親を新たに設定すると Players#bankerもそれに追随する
    players.banker = @player1
    assert_same @player1, players.banker
  end

  # 親(Banker)が決まったら、その他の参加者が子の組(punters)になる
  def test_punters
    players = ChinChin::Players.new(@player1, @player2, @player3)
    players.banker = @player2
    assert_equal [@player1, @player3], players.punters

    # 親が変わったら、新しい親が子の組から除外され、
    # それまでの親が子の組の最後に加わる
    players.banker = @player1
    assert_equal [@player3, @player2], players.punters
  end

  # ゲームに参加していないモノを親にする場合は例外が発生
  def test_banker_has_not_players_error
    players = ChinChin::Players.new(@player1, @player2)

    # exception class
    assert_raise ChinChin::Players::NotJoinedPlayersError do
      players.banker = @player3
    end

    # exception message
    assert_raise "banker has not joined game." do
      players.banker = @player3
    end
  end

  def test_duplicate_player_name_error
    duplicate1 = StabPlayer.new("duplicate")
    duplicate2 = StabPlayer.new("duplicate")
    players = ChinChin::Players.new(@player1, duplicate1)

    # exception class
    assert_raise ChinChin::Players::DuplicatePlayerNameError do
      players.add_player(duplicate2)
    end
  end
end
