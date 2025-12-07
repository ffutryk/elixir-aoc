defmodule AdventOfCode.Y2025.D07 do
  defp handle_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  defp find_start_position(grid) do
    grid |> hd() |> Enum.find_index(&(&1 == "S"))
  end

  defp solve_part1(args) do
    start_x = find_start_position(args)
    beams = MapSet.new([{start_x, 0}])

    simulate(args, beams, 0)
  end

  defp simulate(grid, beams, count) do
    if MapSet.size(beams) != 0 do
      {next_beams, new_count} = step(grid, beams, count)
      simulate(grid, next_beams, new_count)
    else
      count
    end
  end

  defp step(grid, beams, count) do
    Enum.reduce(beams, {MapSet.new(), count}, fn {x, y}, {acc_beams, acc_count} ->
      {new_positions, new_count} = advance(grid, {x, y}, acc_count)
      new_beams = Enum.reduce(new_positions, acc_beams, &MapSet.put(&2, &1))
      {new_beams, new_count}
    end)
  end

  defp advance(grid, {x, y}, count) do
    if at_bottom?(grid, y) do
      {[], count}
    else
      get_cell(grid, x, y)
      |> apply_behaviour({x, y}, count)
    end
  end

  def apply_behaviour("^", {x, y}, count), do: {[{x - 1, y + 1}, {x + 1, y + 1}], count + 1}
  def apply_behaviour(cell, {x, y}, count) when cell in ["S", "."], do: {[{x, y + 1}], count}
  defp get_cell(grid, x, y), do: grid |> Enum.at(y) |> Enum.at(x)
  defp at_bottom?(grid, y), do: y >= length(grid) - 1

  defp solve_part2(args) do
    start_x = find_start_position(args)
    cache = %{}

    count_timelines(args, {start_x, 0}, cache) |> elem(0)
  end

  defp count_timelines(grid, {x, y} = pos, memo) do
    cond do
      at_bottom?(grid, y) ->
        {1, memo}

      Map.has_key?(memo, pos) ->
        {memo[pos], memo}

      true ->
        cell = get_cell(grid, x, y)
        compute_timelines(grid, pos, cell, memo)
    end
  end

  defp compute_timelines(grid, {x, y}, "^", memo) do
    {left_count, memo} =
      if x > 0,
        do: count_timelines(grid, {x - 1, y + 1}, memo),
        else: {0, memo}

    {right_count, memo} =
      if x < grid_width(grid),
        do: count_timelines(grid, {x + 1, y + 1}, memo),
        else: {0, memo}

    total = left_count + right_count
    {total, Map.put(memo, {x, y}, total)}
  end

  defp compute_timelines(grid, {x, y}, cell, memo) when cell in [".", "S"],
    do: count_timelines(grid, {x, y + 1}, memo)

  defp grid_width(grid), do: grid |> hd() |> length()

  def part1(input), do: handle_input(input) |> solve_part1()
  def part2(input), do: handle_input(input) |> solve_part2()
  def main(input), do: handle_input(input) |> then(&{solve_part1(&1), solve_part2(&1)})
end
