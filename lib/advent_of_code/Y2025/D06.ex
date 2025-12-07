defmodule AdventOfCode.Y2025.D06 do
  defp handle_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
    |> transpose()
  end

  defp parse_row(row) do
    row
    |> String.split(" ", trim: true)
    |> Enum.map(&parse_if_numeric/1)
  end

  defp parse_if_numeric(s) do
    s = String.trim(s)

    case Integer.parse(s) do
      {int, ""} -> int
      _ -> s
    end
  end

  defp handle_input_part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row_part2/1)
    |> transpose()
    |> Enum.map(&parse_column/1)
    |> Enum.reject(&is_nil/1)
  end

  defp parse_column(chars) do
    {op, digits} = List.pop_at(chars, -1)

    number =
      digits
      |> Enum.join()
      |> String.trim()

    op = blank_to_nil(op)

    case number do
      "" -> nil
      _ -> [String.to_integer(number), op]
    end
  end

  defp blank_to_nil(s) do
    s = String.trim(s)
    if s == "", do: nil, else: s
  end

  defp transpose(rows), do: Enum.zip(rows) |> Enum.map(&Tuple.to_list/1)

  defp parse_row_part2(row),
    do: String.split(row, "") |> Enum.reverse()

  defp solve_part1(args) do
    args
    |> Stream.map(&solve_problem/1)
    |> Enum.sum()
  end

  defp solve_problem(problem) do
    {op, args} = problem |> List.pop_at(-1)
    operate(args, op)
  end

  defp operate(args, "+"), do: Enum.sum(args)
  defp operate(args, "*"), do: Enum.product(args)

  defp solve_part2(args) do
    compute_blocks(args, [], [])
    |> Enum.sum()
  end

  defp compute_blocks([], _block, results), do: results

  defp compute_blocks([[number, nil] | remaining], block, results),
    do: compute_blocks(remaining, [number | block], results)

  defp compute_blocks([[number, op] | remaining], block, results) do
    block = [number | block]
    result = operate(block, op)
    compute_blocks(remaining, [], [result | results])
  end

  @spec part1(binary()) :: number()
  def part1(input), do: handle_input(input) |> solve_part1()
  def part2(input), do: handle_input_part2(input) |> solve_part2()
  def main(input), do: {part1(input), part2(input)}
end
