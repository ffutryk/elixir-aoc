defmodule AdventOfCode.Y2025.D05 do
  defp handle_input(input) do
    [ranges, ingredients] =
      input
      |> String.split("\n\n", trim: true)

    {parse_ranges(ranges), parse_ingredients(ingredients)}
  end

  defp parse_ranges(ranges) do
    ranges
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_range/1)
  end

  defp parse_range(range) do
    [start, stop] = String.split(range, "-", parts: 2)
    {String.to_integer(start), String.to_integer(stop)}
  end

  defp parse_ingredients(ingredients) do
    ingredients
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp solve_part1({ranges, ingredients}) do
    ranges =
      ranges
      |> normalize_ranges()

    ingredients
    |> Enum.count(fn ingredient ->
      is_fresh?(ingredient, ranges)
    end)
  end

  defp normalize_ranges(ranges) do
    ranges
    |> sort_ranges()
    |> merge_ranges()
  end

  defp sort_ranges(ranges) do
    Enum.sort_by(ranges, fn {start, _} -> start end)
  end

  defp merge_ranges(ranges) do
    ranges
    |> Enum.reduce([], &merge/2)
    |> Enum.reverse()
  end

  def merge(interval, []), do: [interval]
  def merge({s, e}, [{start, stop} | rest]) when s <= stop, do: [{start, max(stop, e)} | rest]
  def merge(interval, acc), do: [interval | acc]

  defp is_fresh?(ingredient, ranges) do
    Enum.any?(ranges, &in_range?(ingredient, &1))
  end

  defp in_range?(n, {start, stop}), do: start <= n && n <= stop

  defp solve_part2({ranges, _ingredients}) do
    ranges
    |> normalize_ranges()
    |> Enum.sum_by(fn {s, e} -> e - s + 1 end)
  end

  def part1(input), do: handle_input(input) |> solve_part1()
  def part2(input), do: handle_input(input) |> solve_part2()
  def main(input), do: handle_input(input) |> then(&{solve_part1(&1), solve_part2(&1)})
end
