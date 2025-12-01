defmodule AdventOfCode.Y2025.D01Test do
  use ExUnit.Case

  alias AdventOfCode.Y2025.D01, as: Day

  @sample_input """
  L68
  L30
  R48
  L5
  R60
  L55
  L1
  L99
  R14
  L82
  """

  @expected_part1 3
  @expected_part2 6

  test "part1/1 returns expected result" do
    assert Day.part1(@sample_input) == @expected_part1
  end

  test "part2/1 returns expected result" do
    assert Day.part2(@sample_input) == @expected_part2
  end
end
