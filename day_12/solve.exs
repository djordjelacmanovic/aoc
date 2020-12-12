dir_val = fn
  :north -> 0
  :east -> 1
  :south -> 2
  :west -> 3
end

val_dir = fn
  0 -> :north
  1 -> :east
  2 -> :south
  3 -> :west
end

rot = fn dir, rot_a ->
  dir
  |> dir_val.()
  |> Kernel.+(rot_a |> div(90))
  |> rem(4)
  |> (fn
        i when i < 0 -> i + 4
        i -> i
      end).()
  |> val_dir.()
end

move = fn
  "F" <> amount, %{dist: {north, west}, dir: :east} ->
    %{dist: {north, west - String.to_integer(amount)}, dir: :east}

  "F" <> amount, %{dist: {north, west}, dir: :west} ->
    %{dist: {north, west + String.to_integer(amount)}, dir: :west}

  "F" <> amount, %{dist: {north, west}, dir: :north} ->
    %{dist: {north + String.to_integer(amount), west}, dir: :north}

  "F" <> amount, %{dist: {north, west}, dir: :south} ->
    %{dist: {north - String.to_integer(amount), west}, dir: :south}

  "N" <> amount, state = %{dist: {north, west}} ->
    %{state | dist: {north + String.to_integer(amount), west}}

  "S" <> amount, state = %{dist: {north, west}} ->
    %{state | dist: {north - String.to_integer(amount), west}}

  "W" <> amount, state = %{dist: {north, west}} ->
    %{state | dist: {north, west + String.to_integer(amount)}}

  "E" <> amount, state = %{dist: {north, west}} ->
    %{state | dist: {north, west - String.to_integer(amount)}}

  "L" <> amount, state = %{dir: dir} ->
    %{state | dir: rot.(dir, -String.to_integer(amount))}

  "R" <> amount, state = %{dir: dir} ->
    %{state | dir: rot.(dir, String.to_integer(amount))}
end

rot_w = fn {dn, dw}, amt ->
  case amt do
    0 -> {dn, dw}
    90 -> {dw, -dn}
    180 -> {-dn, -dw}
    270 -> {-dw, dn}
  end
end

move_wp = fn
  "R" <> amount, {ship, wp} ->
    {ship, rot_w.(wp, String.to_integer(amount))}

  "L" <> amount, {ship, wp} ->
    {ship, rot_w.(wp, 360 - String.to_integer(amount))}

  "F" <> times, {_ship = {n, w}, wp = {dn, dw}} ->
    {{n + dn * String.to_integer(times), w + dw * String.to_integer(times)}, wp}

  cmd, {ship, wp} ->
    {ship, move.(cmd, %{dist: wp}) |> Map.get(:dist)}
end

read = fn ->
  System.argv()
  |> File.stream!()
  |> Enum.map(&String.trim/1)
end

calc_dist = fn r ->
  r
  |> (fn {n, w} -> abs(n) + abs(w) end).()
end

part1 = fn ->
  read.()
  |> Enum.reduce(%{dist: {0, 0}, dir: :east}, &move.(&1, &2))
  |> Map.get(:dist)
  |> calc_dist.()
end

part2 = fn ->
  read.()
  |> Enum.reduce({{0, 0}, {1, -10}}, &move_wp.(&1, &2))
  |> (fn {sp, _} -> calc_dist.(sp) end).()
end

IO.puts("First part: #{part1.()}")
IO.puts("Second part: #{part2.()}")
