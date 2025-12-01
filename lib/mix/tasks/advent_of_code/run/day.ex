defmodule Mix.Tasks.AdventOfCode.Run.Day do
  use Mix.Task

  @shortdoc "Runs an Advent of Code day's solution"

  @moduledoc """
  Runs a specific Advent of Code solution module with its corresponding input.

  ## Examples

      mix advent_of_code.run.day --year 2025 --day 25
      mix advent_of_code.run.day -y 2023 -d 1

  ## Options
    * `--year`, `-y` — Year of the challenge (default: inferred)
    * `--day`,  `-d` — Day number
  """

  @impl true
  def run(argv) do
    Mix.Task.run("app.start")

    {opts, _, _} =
      OptionParser.parse(argv,
        switches: [year: :integer, day: :integer],
        aliases: [y: :year, d: :day]
      )

    ensure_day_and_year!(opts)

    {:ok, now} = DateTime.now("America/New_York")
    year = Keyword.get(opts, :year, now.year)
    day = Keyword.fetch!(opts, :day)

    module = module_for(year, day)
    input = AdventOfCode.Input.get!(day, year)

    Mix.shell().info("== Advent of Code #{year} Day #{day} ==")
    Mix.shell().info("Using module: #{inspect(module)}")
    Mix.shell().info("Input loaded (#{byte_size(input)} bytes)\n")

    run_parts(module, input)
  end

  defp ensure_day_and_year!(opts) do
    if not Keyword.has_key?(opts, :day) do
      Mix.raise("Missing required option: --day")
    end
  end

  defp module_for(year, day) do
    day_mod = day |> Integer.to_string() |> String.pad_leading(2, "0")
    Module.concat([AdventOfCode, "Y#{year}", "D#{day_mod}"])
  end

  defp run_parts(module, input) do
    ensure_loaded!(module)

    cond do
      function_exported?(module, :main, 1) ->
        {p1, p2} = module.main(input)
        print_result(:part1, p1)
        print_result(:part2, p2)

      true ->
        p1 = call_part(module, :part1, input)
        p2 = call_part(module, :part2, input)

        print_result(:part1, p1)
        print_result(:part2, p2)
    end
  end

  defp ensure_loaded!(module) do
    case Code.ensure_loaded(module) do
      {:module, _} -> :ok
      _ -> Mix.raise("Module #{inspect(module)} not found.")
    end
  end

  defp call_part(module, fun, input) do
    if function_exported?(module, fun, 1) do
      apply(module, fun, [input])
    else
      {:error, :not_implemented}
    end
  end

  defp print_result(part, {:error, :not_implemented}) do
    Mix.shell().info("#{part |> format_part()} => NOT IMPLEMENTED\n")
  end

  defp print_result(part, value) do
    Mix.shell().info("#{part |> format_part()} => #{inspect(value)}\n")
  end

  defp format_part(:part1), do: "Part 1"
  defp format_part(:part2), do: "Part 2"
end
