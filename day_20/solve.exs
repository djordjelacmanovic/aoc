defmodule Solution do
  def part1() do
    read()
    |> edges_ids()
    |> Enum.filter(fn {_, ids} -> length(ids) == 1 end)
    |> Enum.group_by(fn {_, [id]} -> id end)
    |> Enum.filter(fn {_id, es} -> length(es) == 4 end)
    |> IO.inspect(label: "corner tiles")
    |> Enum.reduce(1, fn {id, _}, acc -> acc * id end)
  end

  defp read() do
    System.argv()
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.chunk_by(&(&1 != ""))
    |> Enum.reject(&(&1 == [""]))
    |> Enum.map(&parse_tile/1)
    |> Enum.into(%{})
  end

  defp edges_ids(tilemap) do
    Enum.flat_map(tilemap, fn {id, cells} ->
      edges(cells) |> Enum.map(&{id, &1})
    end)
    |> Enum.reduce(%{}, fn {tid, edge}, e ->
      Map.update(e, edge, [tid], fn tids -> [tid | tids] end)
    end)
  end

  defp edges(cells) do
    [north | rr] = rows(cells)
    south = Enum.at(rr, -1)
    [west | rc] = cols(cells)
    east = Enum.at(rc, -1)

    edges = [north, east, south, west]
    edges ++ Enum.map(edges, &flip/1)
  end

  defp flip(edge), do: Enum.reverse(edge)

  defp rows(cells) do
    for y <- 0..9 do
      Enum.at(cells, y)
    end
  end

  defp cols(cells) do
    for x <- 0..9 do
      for y <- 0..9 do
        cells |> Enum.at(y) |> Enum.at(x)
      end
    end
  end

  defp parse_tile([tile_id | tile]),
    do:
      {Regex.run(~r/\d+/, tile_id) |> hd() |> String.to_integer(),
       tile |> Enum.map(&String.graphemes/1)}
end

Solution.part1() |> IO.inspect()
