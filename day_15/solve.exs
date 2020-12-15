defmodule Solution do
  def part1() do
    solve(2020)
  end

  def part2() do
    solve(30_000_000)
  end

  defp solve(max_t) do
    input = [15, 5, 1, 4, 7, 0]

    input
    |> Enum.with_index(1)
    |> Enum.take(length(input) - 1)
    |> Enum.into(%{})
    |> iter(length(input) + 1, List.last(input), max_t + 1)
  end

  defp iter(_memo, turn, prev, max_turn) when max_turn == turn, do: prev

  defp iter(memo, turn, prev, max_turn) do
    IO.write(
      "\rTurn #{turn}/#{max_turn - 1} (#{(turn / (max_turn - 1) * 100) |> Float.round(2)}%)"
    )

    case Map.get(memo, prev) do
      nil ->
        iter(memo |> Map.put(prev, turn - 1), turn + 1, 0, max_turn)

      prt ->
        iter(
          memo |> Map.put(prev, turn - 1),
          turn + 1,
          turn - prt - 1,
          max_turn
        )
    end
  end
end

# duplicate spaces so we overwrite the progress info from before
IO.puts("\rFirst part: #{Solution.part1()}" <> String.duplicate(" ", 50))
IO.puts("\rSecond part: #{Solution.part2()}" <> String.duplicate(" ", 50))
