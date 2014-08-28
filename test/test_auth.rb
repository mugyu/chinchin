#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

app = File.expand_path("../app", File.dirname(__FILE__))
$LOAD_PATH.unshift(app) unless $LOAD_PATH.include?(app)
require "test/unit"
require "models/auth"

# test/unit Auth
class TestAuth < Test::Unit::TestCase
  def setup
    authentications = [
      { user: "user", password: "papAq5PwY/QQM" },
      { user: "hoge", password: "piXp/zeI/Nvso" }
    ]
    @auth = Models::Auth.new(authentications)
  end

  def test_authenticate
    assert_equal(true, @auth.authenticate("user", "password"))
    assert_equal(true, @auth.authenticate("hoge", "piyopiyo"))
    assert_equal(false, @auth.authenticate("user", "pazzword"))
    assert_equal(false, @auth.authenticate("usr", "password"))
  end
end
