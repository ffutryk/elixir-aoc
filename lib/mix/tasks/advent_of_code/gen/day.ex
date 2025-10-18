defmodule Mix.Tasks.AdventOfCode.Gen.Day do
  use Mix.Task

  @template_dir "lib/mix/tasks/advent_of_code/gen/templates"
  @lib_base_dir "lib/advent_of_code"
  @test_base_dir "test/advent_of_code"

  @moduledoc """
  Generates a module with stubbed functions for part 1 and part 2 of an Advent of Code puzzle,
  along with a test file.

  ## Example

      mix advent_of_code.gen.day --year 2025 --day 25

  ## Options

    * `--year`, `-y` - The year of the challenge
    * `--day`, `-d` - The day number
    * `--force`, `-f` - Overwrite existing files
  """

  @shortdoc "Generates a skeleton module and test for an Advent of Code puzzle"

  @impl true
  def run(argv) do
    {opts, _, _} =
      OptionParser.parse(argv,
        switches: [year: :integer, day: :integer, force: :boolean],
        aliases: [y: :year, d: :day, f: :force]
      )

    {:ok, now} = DateTime.now("America/New_York")

    year = Keyword.get(opts, :year, now.year) |> advent_year()
    day = Keyword.get(opts, :day, now.day) |> advent_day()

    generate_skeleton(
      year: year,
      day: day,
      force?: Keyword.get(opts, :force, false)
    )

    Mix.shell().info("\nSuccessfully generated AoC skeleton for Y#{year}D#{day}.\n")
  end

  defp day_module(day), do: "D#{String.pad_leading("#{day}", 2, "0")}"
  defp year_folder(year), do: "Y#{year}"

  defp generate_skeleton(opts) do
    year_folder = year_folder(opts[:year])
    day_module = day_module(opts[:day])

    assigns = [module_path: "#{year_folder}.#{day_module}"]

    [
      {:module, @lib_base_dir, "#{day_module}.ex"},
      {:test, @test_base_dir, "#{day_module}_test.exs"}
    ]
    |> Enum.each(fn {type, base_dir, filename} ->
      dir = Path.join(base_dir, year_folder)
      code = render_template(type, assigns)
      generate_code_file(dir, filename, code, opts[:force?])
    end)
  end

  defp generate_code_file(dir, filename, code, force?) do
    file_path = Path.join(dir, filename)
    exists? = File.exists?(file_path)

    if exists? and not force? do
      Mix.raise("File already exists: #{file_path}. Use --force to overwrite.")
    end

    File.mkdir_p!(dir)
    File.write!(file_path, code)

    status = if exists?, do: "Overwritten", else: "Generated"
    Mix.shell().info("#{status} #{file_path}")
  end

  defp render_template(:module, assigns), do: render_template("module.ex.eex", assigns)
  defp render_template(:test, assigns), do: render_template("test.exs.eex", assigns)

  defp render_template(template, assigns) do
    template_path = Path.join(@template_dir, template)
    EEx.eval_file(template_path, assigns)
  end

  defp advent_day(day), do: validate_bounds(day, 1, 25, "day number (1-25)")
  defp advent_year(year), do: validate_bounds(year, 2015, :infinity, "year (>= 2015)")

  defp validate_bounds(value, min, max, error_msg) do
    if not (value >= min and (max == :infinity or value <= max)) do
      Mix.raise("Value #{value} is outside the valid range for #{error_msg}.")
    end

    value
  end
end
