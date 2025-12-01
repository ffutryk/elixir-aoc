defmodule AdventOfCode.Y2025.D01 do
  defp handle_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
  end

  defp parse_instruction("L" <> amount), do: -String.to_integer(amount)
  defp parse_instruction("R" <> amount), do: +String.to_integer(amount)

  defp solve_part1(args) do
    {_dial, count} =
      Enum.reduce(args, {50, 0}, fn offset, {dial, count} ->
        next = rotate(dial, offset)
        {next, count + count_zero(next)}
      end)

    count
  end

  defp rotate(dial, offset), do: Integer.mod(dial + offset, 100)
  defp count_zero(0), do: 1
  defp count_zero(_), do: 0

  defp solve_part2(args) do
    {_dial, count} =
      Enum.reduce(args, {50, 0}, fn offset, {dial, count} ->
        next = rotate(dial, offset)
        {next, count + count_wraps(dial, dial + offset)}
      end)

    count
  end

  defp count_wraps(dial, next) when dial != 0 and next <= 0, do: abs(div(next, 100)) + 1
  defp count_wraps(_dial, next), do: abs(div(next, 100))

  def part1(input), do: handle_input(input) |> solve_part1()
  def part2(input), do: handle_input(input) |> solve_part2()
  def main(input), do: handle_input(input) |> then(&{solve_part1(&1), solve_part2(&1)})
end
