defmodule AdventOfCode.Y2025.D04 do
  @deltas [
    {-1, -1},
    {0, -1},
    {1, -1},
    {-1, 0},
    {1, 0},
    {-1, 1},
    {0, 1},
    {1, 1}
  ]

  defp handle_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, x}, line_acc ->
        Map.put(line_acc, {x, y}, char)
      end)
    end)
  end

  defp solve_part1(args) do
    count_liftable_paperrolls(args)
  end

  defp count_liftable_paperrolls(grid) do
    Enum.count(grid, fn {pos, char} ->
      count?(grid, pos, char)
    end)
  end

  defp count?(grid, {x, y}, "@"), do: is_liftable?(grid, x, y)
  defp count?(_grid, {_x, _y}, _), do: false

  defp is_liftable?(grid, x, y), do: amount_of_neighbours(grid, x, y) < 4

  defp amount_of_neighbours(grid, x, y) do
    Enum.count(@deltas, fn {dx, dy} ->
      Map.get(grid, {x + dx, y + dy}) == "@"
    end)
  end

  defp solve_part2(args) do
    run(args, 0)
  end

  defp run(grid, total) do
    case step(grid) do
      {_new, 0} -> total
      {new, lifted} -> run(new, total + lifted)
    end
  end

  defp step(grid) do
    initial_acc = {Map.new(), 0}

    {new, lifted} =
      Enum.reduce(grid, initial_acc, fn {{x, y} = pos, char}, {acc_map, lifted} ->
        action(grid, x, y, pos, char, acc_map, lifted)
      end)

    {new, lifted}
  end

  defp action(grid, x, y, pos, "@", acc_map, lifted) do
    ref =
      if is_liftable?(grid, x, y),
        do: &lift/3,
        else: &keep/3

    ref.({acc_map, lifted}, pos, "@")
  end

  defp action(_grid, _x, _y, pos, char, acc_map, lifted),
    do: nothing({acc_map, lifted}, pos, char)

  defp lift({acc_map, lifted}, pos, _char), do: {Map.put(acc_map, pos, "."), lifted + 1}
  defp keep({acc_map, lifted}, pos, _char), do: {Map.put(acc_map, pos, "@"), lifted}
  defp nothing({acc_map, lifted}, pos, char), do: {Map.put(acc_map, pos, char), lifted}

  def part1(input), do: handle_input(input) |> solve_part1()
  def part2(input), do: handle_input(input) |> solve_part2()
  def main(input), do: handle_input(input) |> then(&{solve_part1(&1), solve_part2(&1)})
end
