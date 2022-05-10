require 'minitest/autorun'
require './main'
require 'json'

class SampleTest < Minitest::Test
  def test_main
    expected = File.open("#{__dir__}/../../../expected/ex01.json") do |f|
      JSON.load(f, nil, symbolize_names: true, create_additions: false)
    end

    100.times do
      actual = main
      assert_equal expected, actual
    end
  end
end
