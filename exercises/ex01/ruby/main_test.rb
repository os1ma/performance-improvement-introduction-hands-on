require 'minitest/autorun'
require './main'

class SampleTest < Minitest::Test
  def test_main
    100.times do
      actual = main

      assert_equal 100, actual.length
    end
  end
end
