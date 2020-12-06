solve = fn set_op ->
  System.argv()
  |> File.stream!()
  |> Enum.map(&MapSet.new(to_charlist(String.trim(&1))))
  |> Enum.chunk_by(&Enum.empty?/1)
  |> Enum.map(&Enum.count(Enum.reduce(&1, fn s, acc -> set_op.(s, acc) end)))
  |> Enum.sum()
end

IO.puts("First part: #{solve.(&MapSet.union/2)}")
IO.puts("Second part: #{solve.(&MapSet.intersection/2)}")
