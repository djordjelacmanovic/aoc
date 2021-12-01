defmodule Solution do
  def part1() do
    solve(3)
  end

  def part2() do
    solve(4)
  end

  defp solve(dims) do
    read(dims)
    |> evolve(6, 1)
    |> Map.values()
    |> Enum.count(&(&1 == "#"))
  end

  defp evolve(cells, target_gen, curr_gen) when curr_gen > target_gen, do: cells

  defp evolve(cells, target_gen, curr_gen) do
    new_state =
      cells
      |> expand_with_neighbours()
      |> Enum.reduce(%{}, fn t = {c, _}, acc -> Map.put(acc, c, calc_new_state(cells, t)) end)

    evolve(
      new_state,
      target_gen,
      curr_gen + 1
    )
  end

  defp expand_with_neighbours(state) do
    state
    |> Map.keys()
    |> Enum.flat_map(&neighbouring_coords/1)
    |> Enum.reduce(state, &Map.put_new(&2, &1, "."))
  end

  defp neighbouring_coords(coord = {_x, _y, _z}), do: vectors() |> Enum.map(&add_vec(&1, coord))

  defp neighbouring_coords(coord = {_x, _y, _z, _w}),
    do: vectors(4) |> Enum.map(&add_vec(&1, coord))

  defp calc_new_state(cells, {coord, "#"}) do
    case count_neighbours(cells, coord) do
      2 -> "#"
      3 -> "#"
      _ -> "."
    end
  end

  defp calc_new_state(cells, {coord, "."}) do
    case count_neighbours(cells, coord) do
      3 -> "#"
      _ -> "."
    end
  end

  defp count_neighbours(cells, coord = {_x, _y, _z}) do
    vectors()
    |> Enum.map(&add_vec(&1, coord))
    |> Enum.map(&Map.get(cells, &1))
    |> Enum.count(&(&1 == "#"))
  end

  defp count_neighbours(cells, coord = {_x, _y, _z, _w}) do
    vectors(4)
    |> Enum.map(&add_vec(&1, coord))
    |> Enum.map(&Map.get(cells, &1))
    |> Enum.count(&(&1 == "#"))
  end

  defp add_vec({x, y, z}, {a, b, c}), do: {x + a, y + b, z + c}
  defp add_vec({x, y, z, w}, {a, b, c, d}), do: {x + a, y + b, z + c, w + d}

  defp vectors(dims \\ 3)

  defp vectors(_dims = 3),
    do: for(x <- -1..1, y <- -1..1, z <- -1..1, do: {x, y, z}) |> Enum.reject(&(&1 == {0, 0, 0}))

  defp vectors(_dims = 4),
    do:
      for(x <- -1..1, y <- -1..1, z <- -1..1, w <- -1..1, do: {x, y, z, w})
      |> Enum.reject(&(&1 == {0, 0, 0, 0}))

  defp read(dims) do
    System.argv()
    |> File.stream!()
    |> Enum.with_index()
    |> Enum.flat_map(fn {l, y} ->
      l
      |> String.trim()
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {c, x} ->
        case dims do
          3 -> {{x, y, 0}, c}
          4 -> {{x, y, 0, 0}, c}
        end
      end)
    end)
    |> Enum.into(%{})
  end
end

IO.puts("First part: #{Solution.part1()}")
IO.puts("Second part: #{Solution.part2()}")
