defmodule Solution do
  def part1() do
    read()
    |> iterate(&next_state/2)
    |> count_occupied()
  end

  def part2() do
    read()
    |> iterate(&next_state(&1, &2, fn a, b -> visible_occupied_seats(a, b) end, 4))
    |> count_occupied()
  end

  defp iterate(map, state_mapper) do
    case new_state =
           Enum.reduce(map, %{}, fn c = {pos, _}, new_state ->
             Map.put(new_state, pos, state_mapper.(c, map))
           end) do
      ^map -> new_state
      _ -> iterate(new_state, state_mapper)
    end
  end

  defp visible_occupied_seats(map, pos) do
    directions()
    |> Enum.map(&first_seat_visible(pos, &1, map))
    |> count_occupied()
  end

  defp first_seat_visible({r, c}, vec = {dr, dc}, map) do
    case Map.get(map, {r + dr, c + dc}) do
      :floor -> first_seat_visible({r + dr, c + dc}, vec, map)
      nil -> nil
      state -> state
    end
  end

  defp next_state(c, m, sc_fn \\ &occupied_neighbours/2, max_taken \\ 3)

  defp next_state({pos, :empty}, map, seat_counter_fn, _) do
    case seat_counter_fn.(map, pos) do
      0 -> :taken
      _ -> :empty
    end
  end

  defp next_state({pos, :taken}, map, seat_counter_fn, max_taken) do
    case seat_counter_fn.(map, pos) do
      x when x in 0..max_taken -> :taken
      _ -> :empty
    end
  end

  defp next_state({_, state}, _, _, _), do: state

  defp occupied_neighbours(map, {r, c}) do
    directions()
    |> Enum.map(fn {rd, cd} -> Map.get(map, {r + rd, c + cd}) end)
    |> count_occupied()
  end

  defp directions(), do: [{-1, 0}, {-1, 1}, {-1, -1}, {1, 0}, {1, 1}, {1, -1}, {0, -1}, {0, 1}]

  defp count_occupied(map) when is_map(map),
    do: map |> Map.values() |> Enum.count(&(&1 == :taken))

  defp count_occupied(enum), do: enum |> Enum.count(&(&1 == :taken))

  defp read() do
    System.argv()
    |> File.read!()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(%{}, &Map.merge/2)
  end

  defp parse_line({line, row}) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {char, index}, acc ->
      Map.put(
        acc,
        {row, index},
        case char do
          "L" -> :empty
          "#" -> :taken
          "." -> :floor
        end
      )
    end)
  end
end

IO.puts("First part: #{Solution.part1()}")
IO.puts("Second part: #{Solution.part2()}")
