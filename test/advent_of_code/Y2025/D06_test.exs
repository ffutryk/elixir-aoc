defmodule AdventOfCode.Y2025.D06Test do
  use ExUnit.Case

  alias AdventOfCode.Y2025.D06, as: Day

  @sample_input """
  123 328  51 64 
  45 64  387 23 
    6 98  215 314
  *   +   *   +  
  """

  @expected_part1 4_277_556
  @expected_part2 3_263_827

  test "part1/1 returns expected result" do
    assert Day.part1(@sample_input) == @expected_part1
  end

  test "part2/1 returns expected result" do
    assert Day.part2(@sample_input) == @expected_part2
  end
end
