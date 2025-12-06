defmodule AdventOfCode.Y2025.D05Test do
  use ExUnit.Case

  alias AdventOfCode.Y2025.D05, as: Day

  @sample_input """
  3-5
  10-14
  16-20
  12-18

  1
  5
  8
  11
  17
  32
  """

  @expected_part1 3
  @expected_part2 14

  test "part1/1 returns expected result" do
    assert Day.part1(@sample_input) == @expected_part1
  end

  test "part2/1 returns expected result" do
    assert Day.part2(@sample_input) == @expected_part2
  end
end
