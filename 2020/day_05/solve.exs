System.argv()
|> List.first()
|> File.stream!()
|> Enum.map(&String.split_at(String.trim(&1), -3))
|> Enum.map(fn {rc, cc} ->
  {
    rc |> String.replace("F", "0") |> String.replace("B", "1") |> String.to_integer(2),
    cc |> String.replace("L", "0") |> String.replace("R", "1") |> String.to_integer(2)
  }
end)
|> Enum.map(fn {r, c} -> r * 8 + c end)
|> Enum.sort()
|> (fn l -> {List.last(l), l} end).()
|> (fn {m, l} ->
      %{
        first_part: m,
        second_part:
          l
          |> Enum.chunk_every(2, 1, :discard)
          |> Enum.find(fn [p, c] -> c - p != 1 end)
          |> (fn [p, _] -> p + 1 end).()
      }
    end).()
|> IO.inspect()
