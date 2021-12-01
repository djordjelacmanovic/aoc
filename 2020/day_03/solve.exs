tree? = fn str, i -> String.at(str, rem(i, String.length(str))) == "#" end

solve = fn {rd, cd} ->
  {trees, _} =
    File.stream!("./input")
    |> Stream.map(&String.trim/1)
    |> Stream.with_index()
    |> Enum.reduce({0, 0}, fn
      _, {0, 0} ->
        {0, cd}

      {l, row}, {t, col} when rem(row, rd) == 0 ->
        {t + if(tree?.(l, col), do: 1, else: 0), col + cd}

      _, {t, col} ->
        {t, col}
    end)

  trees
end

IO.puts("First part: #{solve.({1, 3})}")

IO.puts(
  "Second part: " <>
    ([
       {1, 1},
       {1, 3},
       {1, 5},
       {1, 7},
       {2, 1}
     ]
     |> Enum.map(&solve.(&1))
     |> Enum.reduce(1, &(&1 * &2))
     |> to_string())
)
