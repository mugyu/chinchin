$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'test/unit'
require 'chinchin/game'

class TestGame < Test::Unit::TestCase

  # 参加者が登録したとおりである
  def testPlayers
    player1 = Object.new
    player2 = Object.new
    player3 = Object.new

    game = ChinChin::Game.new(player1, player2)
    assert_equal [player1, player2], game.players
    assert_not_equal [player1, player3], game.players

    game = ChinChin::Game.new([player1, player2, player3])
    assert_equal [player1, player2, player3], game.players
  end

  # 親(Banker)の設定と参照
  def testSetBanker
    player1 = Object.new
    player2 = Object.new
    player3 = Object.new

    game = ChinChin::Game.new(player1, player2, player3)
    game.banker = player2
    assert_same player2, game.banker
    assert_not_equal player1, game.banker
    assert_not_equal player3, game.banker

    # 親を新たに設定すると Game#bankerもそれに追随する
    game.banker = player1
    assert_same player1, game.banker
  end

  # 親(Banker)が決まったら、その他の参加者が子の組(punters)になる
  def testPunters
    player1 = Object.new
    player2 = Object.new
    player3 = Object.new

    game = ChinChin::Game.new(player1, player2, player3)
    game.banker = player2
    assert_equal [player1, player3], game.punters

    # 親が変わったら、新しい親が子の組から除外され、
    # それまでの親が子の組に加わる
    game.banker = player3
    assert_equal [player1, player2], game.punters
  end
end
