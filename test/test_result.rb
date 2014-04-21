#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'test/unit'
require 'chinchin/result'

class TestResult < Test::Unit::TestCase
  def setup
  end

  def testScoreIsNotZero
    assert_equal 6, ChinChin::Result.new([1, 1, 6]).score
    assert_equal 5, ChinChin::Result.new([2, 2, 5]).score
    assert_equal 4, ChinChin::Result.new([4, 3, 3]).score
    assert_equal 3, ChinChin::Result.new([3, 4, 4]).score
    assert_equal 2, ChinChin::Result.new([5, 2, 5]).score
    assert_equal 1, ChinChin::Result.new([6, 1, 6]).score
  end

  def testDisjointedPips
    assert_equal 0, ChinChin::Result.new([2, 3, 4]).score
  end
 
  def testScoreOfHifumi
    assert ChinChin::Result.new([1, 2, 3]).score < 0
  end

  def testYakuOfHifumi
    assert_equal :HIFUMI, ChinChin::Result.new([1, 2, 3]).yaku
    assert_equal ChinChin::Result::HIFUMI, :HIFUMI
  end

  def testDices
    pips = [1,2,3]
    assert_same  pips, ChinChin::Result.new(pips).dices
  end
end
