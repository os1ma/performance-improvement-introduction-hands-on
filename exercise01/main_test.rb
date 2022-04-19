require 'minitest/autorun'
require './main'

class SampleTest < Minitest::Test
  def test_find_post_with_tag_names_array_by_user_id
    actual = find_post_with_tag_names_array_by_user_id(1)

    assert_equal 1, actual[0].post_id
    assert_equal 2, actual[1].post_id
    assert_equal 3, actual[2].post_id
    assert_equal 4, actual[3].post_id
    assert_equal 5, actual[4].post_id
  end
end
