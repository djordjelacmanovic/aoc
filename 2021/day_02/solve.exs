defmodule Solution do
  def part1() do
    read()
    |> Enum.reduce({0, 0}, &simple_move/2)
    |> prod()
  end

  def part2() do
    read()
    |> Enum.reduce({0, 0, 0}, &move/2)
    |> prod()
  end

  defp prod({a, b, _}), do: a * b
  defp prod({a, b}), do: a * b

  defp simple_move({:up, val}, {x, y}), do: {x, y - val}
  defp simple_move({:down, val}, {x, y}), do: {x, y + val}
  defp simple_move({:forward, val}, {x, y}), do: {x + val, y}

  defp move({:up, val}, {x, y, a}), do: {x, y, a - val}
  defp move({:down, val}, {x, y, a}), do: {x, y, a + val}
  defp move({:forward, val}, {x, y, a}), do: {x + val, y + a * val, a}

  defp read() do
    System.argv()
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split/1)
    |> Stream.map(fn [dir, val] -> {String.to_atom(dir), String.to_integer(val)} end)
  end
end

IO.puts("First part: #{Solution.part1()}")
IO.puts("First part: #{Solution.part2()}")
