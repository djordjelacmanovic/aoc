read = fn ->
  System.argv()
  |> File.stream!()
  |> Stream.map(&(&1 |> String.trim() |> String.to_integer()))
  |> Enum.sort()
end

part1 = fn ->
  read.()
  |> Enum.chunk_every(2, 1, :discard)
  |> Enum.map(fn [p, c] -> c - p end)
  |> Enum.group_by(& &1)
  |> (fn %{1 => ones, 3 => threes} -> (Enum.count(ones) + 1) * (Enum.count(threes) + 1) end).()
end

# todo: try in constant space
part2 = fn ->
  read.()
  |> Enum.reduce(%{0 => 1}, fn el, acc ->
    Map.put(acc, el, (acc[el - 1] || 0) + (acc[el - 2] || 0) + (acc[el - 3] || 0))
  end)
  |> Map.get(Enum.max(read.()))
end

IO.puts("First part: #{part1.()}")
IO.puts("Second part: #{part2.()}")
