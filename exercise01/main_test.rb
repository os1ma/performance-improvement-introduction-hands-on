require 'minitest/autorun'
require './main'

class SampleTest < Minitest::Test
  def test_sum
    assert_equal 3, sum(1, 2)
  end
end
