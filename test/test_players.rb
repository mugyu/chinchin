#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'test/unit'
require 'chinchin/players'

class TestPlayers < Test::Unit::TestCase

  # プレイヤ用スタブ
  class StabPlayer
    def cast
      self
    end
  end

  # プレイヤ以外用スタブ
  class StabNotPlayer; end

  # 参加者が登録したとおりである
  def testPlayers
    player1 = StabPlayer.new
    player2 = StabPlayer.new
    player3 = StabPlayer.new

    players = ChinChin::Players.new(player1, player2)
    assert_equal [player1, player2], players.to_a
    assert_not_equal [player1, player3], players.to_a

    players = ChinChin::Players.new([player1, player2, player3])
    assert_equal [player1, player2, player3], players.to_a
  end

  # castメソッドを持たないモノを参加者させようとした場合、例外が発生
  def testNotPlayerObjectError
    player1 = StabPlayer.new
    player2 = StabPlayer.new
    notPlayer = StabNotPlayer.new

    # exception class
    assert_raise ChinChin::Players::NotPlayerError do
      ChinChin::Players.new(player1, player2, notPlayer)
    end

    # exception message
    assert_raise "This is not player object. cast method is necessary." do
      ChinChin::Players.new(player1, player2, notPlayer)
    end
  end

  # 親(Banker)の設定と参照
  def testSetBanker
    player1 = StabPlayer.new
    player2 = StabPlayer.new
    player3 = StabPlayer.new

    players = ChinChin::Players.new(player1, player2, player3)
    players.banker = player2
    assert_same player2, players.banker
    assert_not_equal player1, players.banker
    assert_not_equal player3, players.banker

    # 親を新たに設定すると Players#bankerもそれに追随する
    players.banker = player1
    assert_same player1, players.banker
  end

  # 親(Banker)が決まったら、その他の参加者が子の組(punters)になる
  def testPunters
    player1 = StabPlayer.new
    player2 = StabPlayer.new
    player3 = StabPlayer.new

    players = ChinChin::Players.new(player1, player2, player3)
    players.banker = player2
    assert_equal [player1, player3], players.punters

    # 親が変わったら、新しい親が子の組から除外され、
    # それまでの親が子の組の最後に加わる
    players.banker = player1
    assert_equal [player3, player2], players.punters
  end

  # ゲームに参加していないモノを親にする場合は例外が発生
  def testBankerHasNotPlayersError
    player1 = StabPlayer.new
    player2 = StabPlayer.new
    player3 = StabPlayer.new

    players = ChinChin::Players.new(player1, player2)

    # exception class
    assert_raise ChinChin::Players::NotJoinedPlayersError do
      players.banker = player3
    end

    # exception message
    assert_raise "banker has not joined game." do
      players.banker = player3
    end
  end
end
