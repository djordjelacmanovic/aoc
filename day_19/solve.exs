defmodule Solution do
  def part1() do
    {rules, images} = read()
    rule0 = build_rule(rules, 0) |> compile_rule()
    images |> Enum.count(&Regex.match?(rule0, &1))
  end

  defp read() do
    [rules, _, images] =
      System.argv()
      |> File.stream!()
      |> Enum.map(&String.trim/1)
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
        "(" <>
          (Regex.scan(~r/\d+/, complex)
           |> Enum.flat_map(& &1)
           |> Enum.uniq()
           |> Enum.reduce(
             complex,
             &String.replace(
               &2,
               Regex.compile!("(?<!\\d)#{&1}(?!\\d)"),
               build_rule(rule_specs, &1)
             )
           )
           |> String.replace(" ", "")) <> ")"
    end
  end

  defp empty(""), do: true
  defp empty(_str), do: false
end

Solution.part1() |> IO.inspect()
