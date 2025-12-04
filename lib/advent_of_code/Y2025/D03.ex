defmodule AdventOfCode.Y2025.D03 do
  defp handle_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_bank/1)
  end

  defp parse_bank(bank) do
    bank
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp solve_part1(args) do
    Enum.sum_by(args, &max_k_length_number(&1, 2))
  end

  def max_k_length_number(digits, k) do
    drops_allowed = length(digits) - k

    {stack, _} = Enum.reduce(digits, {[], drops_allowed}, &update_stack/2)

    stack
    |> Enum.reverse()
    |> Enum.take(k)
    |> Integer.undigits()
  end

  defp update_stack(digit, {[top | rest], drops}) when drops > 0 and top < digit do
    update_stack(digit, {rest, drops - 1})
  end

  defp update_stack(digit, {stack, drops}) do
    {[digit | stack], drops}
  end

  defp solve_part2(args) do
    Enum.sum_by(args, &max_k_length_number(&1, 12))
  end

  def part1(input), do: handle_input(input) |> solve_part1()
  def part2(input), do: handle_input(input) |> solve_part2()
  def main(input), do: handle_input(input) |> then(&{solve_part1(&1), solve_part2(&1)})
end
