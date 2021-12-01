nums =
  File.stream!("./input")
  |> Stream.map(fn l -> l |> String.trim() |> String.to_integer() end)

find_sum_of = fn nums, target ->
  {_, pair} =
    nums
    |> Enum.reduce_while({MapSet.new(), {}}, fn num, {set, p} ->
      if MapSet.member?(set, target - num),
        do: {:halt, {set, {num, target - num}}},
        else: {:cont, {MapSet.put(set, num), p}}
    end)

  pair
end

mult = &(&1 * &2)
mult_p = fn {x, y} -> mult.(x, y) end

can_sum_to? = fn nums, el -> match?({_, _}, find_sum_of.(nums, el)) end

IO.puts("First part: #{nums |> find_sum_of.(2020) |> mult_p.()}")
n = nums |> Enum.find(&can_sum_to?.(nums, 2020 - &1))
IO.puts("Second part: #{nums |> find_sum_of.(2020 - n) |> mult_p.() |> mult.(n)}")
