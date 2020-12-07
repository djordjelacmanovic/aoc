defmodule Solver do
  def part1() do
    graph = read_to_graph()

    graph
    |> Map.keys()
    |> Enum.reject(&(&1 == "shiny gold"))
    |> Enum.filter(&can_reach?(graph, &1, "shiny gold"))
    |> Enum.count()
  end

  def part2() do
    (read_to_graph()
     |> count_bags("shiny gold")) - 1
  end

  defp count_bags(graph, {colour, number}), do: number * count_bags(graph, colour)

  defp count_bags(graph, colour) do
    graph
    |> Map.get(colour)
    |> Enum.reduce(1, &(count_bags(graph, &1) + &2))
  end

  defp read_to_graph() do
    System.argv()
    |> File.stream!()
    |> Enum.map(&parse_line/1)
    |> Enum.into(%{})
  end

  defp can_reach?(_graph, from_c, c) when from_c == c, do: true

  defp can_reach?(graph, from_colour, colour) do
    graph
    |> Map.get(from_colour)
    |> Map.keys()
    |> Enum.any?(&can_reach?(graph, &1, colour))
  end

  defp parse_line(line) do
    [bag, bags_inside] = line |> String.split("bags contain") |> Enum.map(&String.trim/1)

    {bag, parse_inside(bags_inside)}
  end

  defp parse_inside("no other bags."), do: %{}

  defp parse_inside(bags_inside) do
    bags_inside
    |> String.replace(".", "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn num_and_bag ->
      [num, bag] = String.split(num_and_bag, " ", parts: 2)
      {String.replace(bag, ~r/\sbags?/, ""), String.to_integer(num)}
    end)
    |> Enum.into(%{})
  end
end

IO.puts("First part: #{Solver.part1()}")

Solver.part2() |> IO.inspect()
