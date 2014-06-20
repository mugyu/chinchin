#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

ENV["RACK_ENV"] = "test"

test_dir = File.dirname(__FILE__)
root = File.expand_path("..", test_dir)
lib = File.expand_path("../lib", test_dir)
$LOAD_PATH.unshift(root) unless $LOAD_PATH.include?(root)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "test/unit"
require "rack/test"
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
