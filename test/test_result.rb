#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'test/unit'
require 'chinchin/result'

class TestResult < Test::Unit::TestCase
  def setup
  end

  # 目が2つ以上同じならば違う目がスコア
  def testpointIsNotConbo
    assert_equal 6, ChinChin::Result.new([1, 1, 6]).point
    assert_equal 5, ChinChin::Result.new([2, 2, 5]).point
    assert_equal 4, ChinChin::Result.new([4, 3, 3]).point
    assert_equal 3, ChinChin::Result.new([3, 4, 4]).point
    assert_equal 2, ChinChin::Result.new([5, 2, 5]).point
    assert_equal 1, ChinChin::Result.new([6, 1, 6]).point
  end

  # 目がバラバラならばスコアは 0
  def testDisjointedPips
    assert_equal 0, ChinChin::Result.new([2, 3, 4]).point
  end
 
  # 目が 1, 2, 3 ならばスコアは -1
  def testpointOfHifumi
    assert_equal(-1,  ChinChin::Result.new([1, 2, 3]).point)
  end

  # 目が 1, 2, 3 ならば役はヒフミ
  def testYakuOfHifumi
    assert_equal :HIFUMI, ChinChin::Result.new([1, 2, 3]).yaku
    assert_equal ChinChin::Result::HIFUMI, :HIFUMI
  end
 
  # 目が 4, 5, 6 ならばスコアは +10
  def testpointOfShigoro
    assert_equal 10, ChinChin::Result.new([4, 5, 6]).point
  end

  # 目が 4, 5, 6 ならば役はシゴロ
  def testYakuOfShiigoro
    assert_equal :SHIGORO, ChinChin::Result.new([4, 5, 6]).yaku
    assert_equal ChinChin::Result::SHIGORO, :SHIGORO
  end

  # 目が 1, 1, 1 ならばスコアは +11
  def testpointOfArashiWith111
    assert_equal 11, ChinChin::Result.new([1, 1, 1]).point
  end

  # 目が 1, 1, 1 ならば役はアラシ
  def testYakuOfArashiWith111
    assert_equal :ARASHI, ChinChin::Result.new([1, 1, 1]).yaku
    assert_equal ChinChin::Result::ARASHI, :ARASHI
  end

  # 目が 2, 2, 2 ならばスコアは +12
  def testpointOfArashiWith222
    assert_equal 12, ChinChin::Result.new([2, 2, 2]).point
  end

  # 目が 2, 2, 2 ならば役はアラシ
  def testYakuOfArashiWith222
    assert_equal :ARASHI, ChinChin::Result.new([2, 2, 2]).yaku
    assert_equal ChinChin::Result::ARASHI, :ARASHI
  end

  # 目が 3, 3, 3 ならばスコアは +13
  def testpointOfArashiWith333
    assert_equal 13, ChinChin::Result.new([3, 3, 3]).point
  end

  # 目が 3, 3, 3 ならば役はアラシ
  def testYakuOfArashiWith333
    assert_equal :ARASHI, ChinChin::Result.new([3, 3, 3]).yaku
    assert_equal ChinChin::Result::ARASHI, :ARASHI
  end

  # 目が 4, 4, 4 ならばスコアは +14
  def testpointOfArashiWith444
    assert_equal 14, ChinChin::Result.new([4, 4, 4]).point
  end

  # 目が 4, 4, 4 ならば役はアラシ
  def testYakuOfArashiWith444
    assert_equal :ARASHI, ChinChin::Result.new([4, 4, 4]).yaku
    assert_equal ChinChin::Result::ARASHI, :ARASHI
  end

  # 目が 5, 5, 5 ならばスコアは +15
  def testpointOfArashiWith555
    assert_equal 15, ChinChin::Result.new([5, 5, 5]).point
  end

  # 目が 5, 5, 5 ならば役はアラシ
  def testYakuOfArashiWith555
    assert_equal :ARASHI, ChinChin::Result.new([5, 5, 5]).yaku
    assert_equal ChinChin::Result::ARASHI, :ARASHI
  end

  # 目が 6, 6, 6 ならばスコアは +16
  def testpointOfArashiWith666
    assert_equal 16, ChinChin::Result.new([6, 6, 6]).point
  end

  # 目が 6, 6, 6 ならば役はアラシ
  def testYakuOfArashiWith666
    assert_equal :ARASHI, ChinChin::Result.new([6, 6, 6]).yaku
    assert_equal ChinChin::Result::ARASHI, :ARASHI
  end

  # diceプロパティはコンストラクタの引数そのもの
  def testDice
    pips = [1,2,3]
    assert_same  pips, ChinChin::Result.new(pips).dice
  end
end
