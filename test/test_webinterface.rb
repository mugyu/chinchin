#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/.."
require "test/unit"
require "rack/test"
p pwd
require "app/app"

# Web Interface Test
class TestChinChin < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    App
  end

  def test_default
    get "/"
    assert_match(/GAME START/, last_response.body)
  end
end
