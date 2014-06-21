#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

lib = File.expand_path("../lib", File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "test/unit"
require "chinchin/result"

# test/unit result class
class TestResult < Test::Unit::TestCase
  def setup
  end

  # 目が2つ以上同じならば違う目がスコア
  def test_pointis_not_conbo
    assert_equal 6, ChinChin::Result.new([1, 1, 6]).point
    assert_equal 5, ChinChin::Result.new([2, 2, 5]).point
    assert_equal 4, ChinChin::Result.new([4, 3, 3]).point
    assert_equal 3, ChinChin::Result.new([3, 4, 4]).point
    assert_equal 2, ChinChin::Result.new([5, 2, 5]).point
    assert_equal 1, ChinChin::Result.new([6, 1, 6]).point
  end

  # 目がバラバラならばスコアは 0
  def test_disjointed_pips
    assert_equal 0, ChinChin::Result.new([2, 3, 4]).point
  end

  # 目が 1, 2, 3 ならばスコアは -1
  def test_point_of_hifumi
    assert_equal(-1,  ChinChin::Result.new([1, 2, 3]).point)
  end

  # 目が 1, 2, 3 ならば役はヒフミ
  def test_yaku_of_hifumi
    assert_equal :HIFUMI, ChinChin::Result.new([1, 2, 3]).yaku
    assert_equal ChinChin::Result::HIFUMI, :HIFUMI
  end

  # 目が 4, 5, 6 ならばスコアは +10
  def test_point_of_shigoro
    assert_equal 10, ChinChin::Result.new([4, 5, 6]).point
  end

  # 目が 4, 5, 6 ならば役はシゴロ
  def test_yaku_of_shiigoro
    assert_equal :SHIGORO, ChinChin::Result.new([4, 5, 6]).yaku
    assert_equal ChinChin::Result::SHIGORO, :SHIGORO
  end

  # 目が 1, 1, 1 ならばスコアは +11
  def test_point_of_arashi_with_111
    assert_equal 11, ChinChin::Result.new([1, 1, 1]).point
  end

  # 目が 1, 1, 1 ならば役はアラシ
  def test_yaku_of_arashi_with__111
    assert_equal :ARASHI, ChinChin::Result.new([1, 1, 1]).yaku
    assert_equal ChinChin::Result::ARASHI, :ARASHI
  end

  # 目が 2, 2, 2 ならばスコアは +12
  def test_point_of_arashi_with_222
    assert_equal 12, ChinChin::Result.new([2, 2, 2]).point
  end

  # 目が 2, 2, 2 ならば役はアラシ
  def test_yaku_of_arashi_with_222
    assert_equal :ARASHI, ChinChin::Result.new([2, 2, 2]).yaku
    assert_equal ChinChin::Result::ARASHI, :ARASHI
  end

  # 目が 3, 3, 3 ならばスコアは +13
  def test_point_of_arashi_with_333
    assert_equal 13, ChinChin::Result.new([3, 3, 3]).point
  end

  # 目が 3, 3, 3 ならば役はアラシ
  def test_yaku_of_arashi_with_333
    assert_equal :ARASHI, ChinChin::Result.new([3, 3, 3]).yaku
    assert_equal ChinChin::Result::ARASHI, :ARASHI
  end

  # 目が 4, 4, 4 ならばスコアは +14
  def test_point_of_arashi_with_444
    assert_equal 14, ChinChin::Result.new([4, 4, 4]).point
  end

  # 目が 4, 4, 4 ならば役はアラシ
  def test_yaku_of_arashi_with_444
    assert_equal :ARASHI, ChinChin::Result.new([4, 4, 4]).yaku
    assert_equal ChinChin::Result::ARASHI, :ARASHI
  end

  # 目が 5, 5, 5 ならばスコアは +15
  def test_point_of_arashi_with_555
    assert_equal 15, ChinChin::Result.new([5, 5, 5]).point
  end

  # 目が 5, 5, 5 ならば役はアラシ
  def test_yaku_of_arashi_with_555
    assert_equal :ARASHI, ChinChin::Result.new([5, 5, 5]).yaku
    assert_equal ChinChin::Result::ARASHI, :ARASHI
  end

  # 目が 6, 6, 6 ならばスコアは +16
  def test_point_of_arashi_with_666
    assert_equal 16, ChinChin::Result.new([6, 6, 6]).point
  end

  # 目が 6, 6, 6 ならば役はアラシ
  def test_yaku_of_arashi_with_666
    assert_equal :ARASHI, ChinChin::Result.new([6, 6, 6]).yaku
    assert_equal ChinChin::Result::ARASHI, :ARASHI
  end

  # diceプロパティはコンストラクタの引数そのもの
  def test_dice
    pips = [1, 2, 3]
    assert_same pips, ChinChin::Result.new(pips).dice
  end
end
