defmodule AdventOfCode.Y2025.D02 do
  defp handle_input(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&parse_range/1)
  end

  defp parse_range(range) do
    [start, stop] = String.split(range, "-", parts: 2)
    {String.to_integer(start), String.to_integer(stop)}
  end

  defp solve_part1(args) do
    Enum.sum_by(args, &sum_invalids/1)
  end

  defp sum_invalids({start, stop}) do
    start..stop
    |> Stream.filter(&invalid_id?/1)
    |> Enum.sum()
  end

  defp invalid_id?(n) do
    id = Integer.to_string(n)
    len = String.length(id)
    half_point = div(len, 2)

    if rem(len, 2) == 0,
      do: id |> String.split_at(half_point) |> equal_parts?,
      else: false
  end

  defp equal_parts?({x, y}), do: x == y

  defp solve_part2(args) do
    Enum.sum_by(args, &sum_invalids2/1)
  end

  defp sum_invalids2({start, stop}) do
    start..stop
    |> Stream.filter(&invalid_id2?/1)
    |> Enum.sum()
  end

  def invalid_id2?(n) do
    id = Integer.to_string(n)
    len = byte_size(id)

    len >= 2 and
      1..div(len, 2)
      |> Enum.any?(&repeats_exactly?(id, &1))
  end

  defp repeats_exactly?(id, chunk_len) do
    len = byte_size(id)
    chunk = :binary.part(id, 0, chunk_len)

    rem(len, chunk_len) == 0 and id == String.duplicate(chunk, div(len, chunk_len))
  end

  def part1(input), do: handle_input(input) |> solve_part1()
  def part2(input), do: handle_input(input) |> solve_part2()
  def main(input), do: handle_input(input) |> then(&{solve_part1(&1), solve_part2(&1)})
end
