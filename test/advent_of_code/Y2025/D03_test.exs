defmodule AdventOfCode.Y2025.D03Test do
  use ExUnit.Case

  alias AdventOfCode.Y2025.D03, as: Day

  @sample_input """
  987654321111111
  811111111111119
  234234234234278
  818181911112111
  """

  @expected_part1 357
  @expected_part2 3_121_910_778_619

  test "part1/1 returns expected result" do
    assert Day.part1(@sample_input) == @expected_part1
  end

  test "part2/1 returns expected result" do
    assert Day.part2(@sample_input) == @expected_part2
  end
end
