defmodule AdventOfCode.Y2025.D02Test do
  use ExUnit.Case

  alias AdventOfCode.Y2025.D02, as: Day

  @sample_input """
  11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
  """

  @expected_part1 1_227_775_554
  @expected_part2 4_174_379_265

  test "part1/1 returns expected result" do
    assert Day.part1(@sample_input) == @expected_part1
  end

  test "part2/1 returns expected result" do
    assert Day.part2(@sample_input) == @expected_part2
  end
end
