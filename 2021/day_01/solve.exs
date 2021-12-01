defmodule Solution do
  def part1() do
    read()
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.count(fn [prev, curr] -> curr > prev end)
  end

  def part2() do
    read()
    |> Stream.chunk_every(3, 1, :discard)
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.count(fn [fw, sw] -> Enum.sum(sw) > Enum.sum(fw) end)
  end

  defp read() do
    System.argv()
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end
end

IO.puts("First part: #{Solution.part1()}")
IO.puts("Second part: #{Solution.part2()}")
