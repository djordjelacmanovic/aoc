defmodule Solution do
  def part1() do
    solve()
  end

  def part2() do
    solve(fn
      "8:" <> _ -> "8: 42 | 42 8"
      "11:" <> _ -> "11: 42 31 | 42 11 31"
      s -> s
    end)
  end

  defp solve(line_modifier \\ & &1) do
    {rules, images} = read(line_modifier)
    rule0 = build_rule(rules, 0) |> compile_rule()
    images |> Enum.count(&Regex.match?(rule0, &1))
  end

  defp read(mod) do
    [rules, _, images] =
      File.stream!(System.argv())
      |> Enum.map(&String.trim/1)
      |> Enum.map(&mod.(&1))
      |> Enum.chunk_by(&empty/1)

    {rules |> Enum.map(&parse_rule/1) |> Enum.into(%{}), images}
  end

  defp parse_rule(rule_str) do
    [num, rule_spec] = String.split(rule_str, ":")

    {
      String.to_integer(num),
      String.trim(rule_spec)
    }
  end

  defp compile_rule(rule_spec), do: Regex.compile!("^#{rule_spec}$")

  defp build_rule(rule_specs, rule_no) when is_binary(rule_no),
    do: build_rule(rule_specs, String.to_integer(rule_no))

  defp build_rule(rule_specs, rule_no) do
    case rule_specs[rule_no] do
      "\"" <> char ->
        char |> String.replace("\"", "")

      complex ->
        loop_handled = transform_loop(complex, rule_no)

        "(" <>
          (Regex.scan(~r/\d+/, loop_handled)
           |> Enum.flat_map(& &1)
           |> Enum.uniq()
           |> Enum.reduce(
             loop_handled,
             &String.replace(
               &2,
               Regex.compile!("(?<!\\d)#{&1}(?!\\d)"),
               build_rule(rule_specs, &1)
             )
           )
           |> String.replace(" ", "")) <> ")"
    end
  end

  defp transform_loop(str, rule_no) do
    if Regex.match?(Regex.compile!("(?<!\\d)#{rule_no}(?!\\d)"), str) do
      "(?'rec#{num_str(rule_no)}'#{str})"
      |> String.replace(to_string(rule_no), "(?&rec#{num_str(rule_no)})*")
    else
      str
    end
  end

  defp num_str(8), do: "eight"
  defp num_str(11), do: "eleven"

  defp empty(""), do: true
  defp empty(_str), do: false
end

IO.puts("First part: #{Solution.part1()}")
IO.puts("Second part: #{Solution.part2()}")
