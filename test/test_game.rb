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
end
