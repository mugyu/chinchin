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

      attr_reader :yaku, :point, :dice

      def initialize(yaku, point, dice)
        @yaku = yaku
        @point = point
        @dice = dice
      end
    end

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
      [nil, 0, [1, 4, 5]],
      [nil, 0, [2, 4, 5]],
      [nil, 0, [3, 4, 5]]
    ])
    game = ChinChin::Game.new(nothing_and_0)
    result = game.play(nothing_and_0)
    assert_equal nil, result.yaku
    assert_equal 0, result.point
    assert_equal [[1, 4, 5], [2, 4, 5], [3, 4, 5]], result.dice

    # 一投目の出目が1, 後続にそれを上回る出目2 が出現
    nothing_and_2 = StabCheatPlayer.new([
      [nil, 1, [1, 2, 2]],
      [nil, 2, [2, 4, 4]],
      [nil, 0, [1, 3, 6]]
    ])
    game = ChinChin::Game.new(nothing_and_2)
    result = game.play(nothing_and_2)
    assert_equal nil, result.yaku
    assert_equal 2, result.point
    assert_equal [[1, 2, 2], [2, 4, 4], [1, 3, 6]], result.dice

    # 一投目で出目が5、後続は一投目より低い目
    nothing_and_5 = StabCheatPlayer.new([
      [nil, 5, [4, 4, 5]],
      [nil, 4, [2, 4, 2]],
      [nil, 3, [3, 1, 1]]
    ])
    game = ChinChin::Game.new(nothing_and_5)
    result = game.play(nothing_and_5)
    assert_equal nil, result.yaku
    assert_equal 5, result.point
    assert_equal [[4, 4, 5], [2, 4, 2], [3, 1, 1]], result.dice

    # 二投目でヒフミ
    # 役が出来た時点で決する為、二投で終わり
    hifumi = StabCheatPlayer.new([
      [nil, 1, [6, 6, 1]],
      [:HIFUMI, -1, [1, 2, 3]],
    ])
    game = ChinChin::Game.new(hifumi)
    result = game.play(hifumi)
    assert_equal :HIFUMI, result.yaku
    assert_equal(-1, result.point)
    assert_equal [[6, 6, 1], [1, 2, 3]], result.dice
  end

  # プレイヤを参加者一覧に追加する
  # プレイヤを子の組に追加する
  def testAddPlayer
    player1 = StabPlayer.new
    player2 = StabPlayer.new
    player3 = StabPlayer.new

    game = ChinChin::Game.new(player1)

    game.addPlayer(player2)
    game.banker = player1
    game.addPlayer(player3)

    # 参加者
    assert_equal [player1, player2, player3], game.players

    # 子の組
    assert_equal [player2, player3], game.punters
  end

  # プレイヤを参加者一覧から除外する
  # プレイヤを子の組から除外する
  # プレイヤが親の場合は親をnilにする
  def testRemovePlayer
    player1 = StabPlayer.new
    player2 = StabPlayer.new
    player3 = StabPlayer.new

    game = ChinChin::Game.new(player1, player2, player3)

    game.banker = player3
    game.removePlayer(player1)

    # 親
    assert_equal player3, game.banker

    game.removePlayer(player3)

    # 参加者
    assert_equal [player2], game.players

    # 親
    assert_equal nil, game.banker

    # 子の組
    assert_equal [player2], game.punters
  end

  # 親の出目は5
  # 子の目は、
  # - 出目が3の負け
  # - 役がシゴロの勝ち
  # - 出目が5の引き分け
  def testGame
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
      [:SIGORO, 10, [6, 4, 5]],
    ])
    punter3 = StabCheatPlayer.new([
      [nil, 4, [2, 4, 2]],
      [nil, 3, [3, 1, 1]],
      [nil, 5, [4, 4, 5]]
    ])

    game = ChinChin::Game.new(banker, punter1, punter2, punter3)
    game.banker = banker
    result = game.game

    assert_equal nil, result[0][:result].yaku
    assert_equal 5, result[0][:result].point

    assert_equal :Lost, result[1][:status]
    assert_equal nil, result[1][:result].yaku
    assert_equal 3, result[1][:result].point

    assert_equal :Win, result[2][:status]
    assert_equal :SIGORO, result[2][:result].yaku
    assert_equal 10, result[2][:result].point

    assert_equal :Draw, result[3][:status]
    assert_equal nil, result[3][:result].yaku
    assert_equal 5, result[3][:result].point

  end

  # 親の役がアラシなので子は無条件で負け
  # 子の結果が無し
  def testGameBankerWithARASHI
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

    game = ChinChin::Game.new(banker, punter1, punter2)
    game.banker = banker
    result = game.game

    assert_equal :ARASHI, result[0][:result].yaku
    assert_equal 11, result[0][:result].point

    assert_equal :Lost, result[1][:status]
    assert_equal nil, result[1][:result]
    assert_equal :Lost, result[2][:status]
    assert_equal nil, result[2][:result]
  end
end
