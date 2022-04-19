require 'minitest/autorun'
require './main'

class SampleTest < Minitest::Test
  def test_find_post_with_tag_names_array_by_user_id
    100.times do
      actual = find_post_with_tag_names_array_by_user_id(1)
      # actual = fixed(1)

      assert_equal 100, actual.length
    end
  end
end
