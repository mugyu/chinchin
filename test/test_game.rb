$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'test/unit'
require 'chinchin/game'

class TestGame < Test::Unit::TestCase

  # プレイヤ用スタブ
  class StabPlayer
    def cast
      self
    end
  end

  # プレイヤ以外用スタブ
  class StabNotPlayer; end

  # 結果をコントロールできるチーター
  class StabCheatPlayer
    class Result

      NOTHING = :NOTHING

      attr_reader :yaku, :score

      def initialize(yaku, score)
        @yaku = yaku
        @score = score
      end
    end

    def initialize(seed)
      @seed = seed
      @cast_number = 0
    end

    def cast
      yaku, score = @seed[@cast_number]
      @cast_number += 1
      Result.new(yaku, score)
    end
  end

  # 参加者が登録したとおりである
  def testPlayers
    player1 = StabPlayer.new
    player2 = StabPlayer.new
    player3 = StabPlayer.new

    game = ChinChin::Game.new(player1, player2)
    assert_equal [player1, player2], game.players
    assert_not_equal [player1, player3], game.players

    game = ChinChin::Game.new([player1, player2, player3])
    assert_equal [player1, player2, player3], game.players
  end

  # castメソッドを持たないモノを参加者させようとした場合、例外が発生
  def testNotPlayerObjectError
    player1 = StabPlayer.new
    player2 = StabPlayer.new
    notPlayer = StabNotPlayer.new

    # exception class
    assert_raise ChinChin::Game::NotPlayerError do
      ChinChin::Game.new(player1, player2, notPlayer)
    end

    # exception message
    assert_raise "This is not player object. cast method is necessary." do
      ChinChin::Game.new(player1, player2, notPlayer)
    end
  end

  # 親(Banker)の設定と参照
  def testSetBanker
    player1 = StabPlayer.new
    player2 = StabPlayer.new
    player3 = StabPlayer.new

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
    player1 = StabPlayer.new
    player2 = StabPlayer.new
    player3 = StabPlayer.new

    game = ChinChin::Game.new(player1, player2, player3)
    game.banker = player2
    assert_equal [player1, player3], game.punters

    # 親が変わったら、新しい親が子の組から除外され、
    # それまでの親が子の組に加わる
    game.banker = player3
    assert_equal [player1, player2], game.punters
  end

  # ゲームに参加していないモノを親にする場合は例外が発生
  def testBankerHasNotJoinedGameError
    player1 = StabPlayer.new
    player2 = StabPlayer.new
    player3 = StabPlayer.new

    game = ChinChin::Game.new(player1, player2)

    # exception class
    assert_raise ChinChin::Game::NotJoinedGameError do
      game.banker = player3
    end

    # exception message
    assert_raise "banker has not joined game." do
      game.banker = player3
    end
  end

  # 勝負を行った結果を検証(賽を投じた結果では無い)
  def testPlay
    # 目なしの場合
    nothing_and_0 = StabCheatPlayer.new([
      [:NOTHING, 0],
      [:NOTHING, 0],
      [:NOTHING, 0]
    ])
    game = ChinChin::Game.new(nothing_and_0)

    yaku, score = game.play(nothing_and_0)
    assert_equal :NOTHING, yaku
    assert_equal 0, score

    # 一投目の出目が1, 後続にそれを上回る出目2 が出現
    nothing_and_2 = StabCheatPlayer.new([
      [:NOTHING, 1],
      [:NOTHING, 2],
      [:NOTHING, 0]
    ])
    game = ChinChin::Game.new(nothing_and_2)
    yaku, score = game.play(nothing_and_2)
    assert_equal :NOTHING, yaku
    assert_equal 2, score

    # 一投目で出目が5、後続は一投目より低い目
    nothing_and_5 = StabCheatPlayer.new([
      [:NOTHING, 5],
      [:NOTHING, 4],
      [:NOTHING, 3]
    ])
    game = ChinChin::Game.new(nothing_and_5)
    yaku, score = game.play(nothing_and_5)
    assert_equal :NOTHING, yaku
    assert_equal 5, score

    # 一投目でヒフミ
    # 役が出来た時点で決する為、一投で終わり
    hifumi = StabCheatPlayer.new([
      [:HIFUMI, -1],
    ])
    game = ChinChin::Game.new(hifumi)
    yaku, score = game.play(hifumi)
    assert_equal :HIFUMI, yaku
    assert_equal(-1, score)
  end
end
