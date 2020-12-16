defmodule Solution do
  def part1() do
    {_, nearby, rules} = read()
    Enum.flat_map(nearby, &filter_invalid_values(&1, rules)) |> Enum.sum()
  end

  def part2() do
    {my_t, nearby, rules} = read()

    Enum.filter(nearby, &valid_ticket?(&1, rules))
    |> determine_field_indexes(rules)
    |> Enum.filter(fn {n, _} -> String.starts_with?(n, "departure") end)
    |> Enum.map(fn {_, i} -> Enum.at(my_t, i) end)
    |> Enum.reduce(1, &(&1 * &2))
  end

  defp determine_field_indexes(valid_tickets, rules) do
    candidates =
      valid_tickets
      |> Enum.flat_map(&Enum.with_index/1)
      |> Enum.group_by(fn {_, i} -> i end, fn {v, _} -> v end)
      |> Enum.map(fn {i, vals} -> {i, rules_valid_for_all(vals, rules)} end)
      |> Enum.into(%{})

    sieve_candidates(candidates) |> Enum.map(fn {i, [name]} -> {name, i} end) |> Enum.into(%{})
  end

  defp sieve_candidates(candidates, used_up \\ MapSet.new())

  defp sieve_candidates(candidates, used_up) do
    case Enum.map(candidates, fn
           {i, [one]} -> {i, [one]}
           {i, names} -> {i, Enum.filter(names, fn n -> !MapSet.member?(used_up, n) end)}
         end) do
      ^candidates ->
        candidates

      not_done ->
        sieve_candidates(
          not_done,
          Enum.filter(not_done, fn {_, names} -> length(names) == 1 end)
          |> Enum.reduce(used_up, fn {_, [name]}, acc -> MapSet.put(acc, name) end)
        )
    end
  end

  defp rules_valid_for_all(values, rules) do
    Enum.filter(rules, fn r -> Enum.all?(values, &matches_rule?(&1, r)) end)
    |> Enum.map(fn {name, _} -> name end)
  end

  defp valid_ticket?(ticket, rules), do: filter_invalid_values(ticket, rules) |> Enum.empty?()

  defp filter_invalid_values(values, rules),
    do: Enum.filter(values, &matches_no_rules?(&1, rules))

  defp matches_no_rules?(value, rules), do: !Enum.any?(rules, &matches_rule?(value, &1))

  defp matches_rule?(value, {_, fun}), do: fun.(value)

  defp read() do
    [rules, ["your ticket:", my_ticket], ["nearby tickets:" | nearby_tickets]] =
      System.argv()
      |> File.read!()
      |> String.split("\n")
      |> Enum.chunk_by(&empty?/1)
      |> Enum.reject(&(List.first(&1) |> empty?()))

    {
      my_ticket |> String.split(",") |> Enum.map(&String.to_integer/1),
      nearby_tickets
      |> Enum.map(fn t -> t |> String.split(",") |> Enum.map(&String.to_integer/1) end),
      rules |> Enum.map(&parse_rule/1)
    }
  end

  defp parse_rule(rule_str) do
    %{
      "name" => name,
      "frs" => frs,
      "fre" => fre,
      "srs" => srs,
      "sre" => sre
    } =
      Regex.named_captures(
        ~r/(?'name'[^:]+)(?::\s)(?:(?'frs'\d+)-(?'fre'\d+))(?:\sor\s)(?:(?'srs'\d+)-(?'sre'\d+))/,
        rule_str
      )

    first_range_start = String.to_integer(frs)
    first_range_end = String.to_integer(fre)
    second_range_start = String.to_integer(srs)
    second_range_end = String.to_integer(sre)

    {name,
     fn
       val when val >= first_range_start and val <= first_range_end -> true
       val when val >= second_range_start and val <= second_range_end -> true
       _ -> false
     end}
  end

  defp empty?(str), do: String.length(str) == 0
end

IO.puts("First part: #{Solution.part1()}")
IO.puts("Second part: #{Solution.part2()}")
