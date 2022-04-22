require 'minitest/autorun'
require './main'

class SampleTest < Minitest::Test
  def test_main
    actual = main

    assert_equal 10, actual.length
  end
end
