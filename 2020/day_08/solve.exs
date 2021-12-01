defmodule Solver do
  def part1() do
    {result, :loop} = ingest_cmds() |> exec()
    result
  end

  def part2() do
    # will bruteforce it because I cba to do it via graphs
    cmd_map =
      ingest_cmds()
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {cmd, i}, acc -> Map.put(acc, i, cmd) end)

    {result, :finish} =
      cmd_map
      |> Stream.filter(fn
        {_, {:nop, _}} -> true
        {_, {:jmp, _}} -> true
        _ -> false
      end)
      |> Stream.map(fn {i, cmd} ->
        Map.put(
          cmd_map,
          i,
          case cmd do
            {:nop, val} -> {:jmp, val}
            {:jmp, val} -> {:nop, val}
          end
        )
      end)
      |> Stream.map(&exec(&1))
      |> Enum.find(&match?({_, :finish}, &1))

    result
  end

  defp exec(cmds) when is_map(cmds),
    do: 0..(map_size(cmds) - 1) |> Enum.map(&Map.get(cmds, &1)) |> exec()

  defp exec(cmds, curr \\ 0, val \\ 0, ex_cmds \\ MapSet.new()) do
    with false <- MapSet.member?(ex_cmds, curr),
         cmd = {_, _} <- Enum.at(cmds, curr),
         {next_cmd, new_val} <- exec_cmd(cmd, curr, val) do
      exec(cmds, next_cmd, new_val, MapSet.put(ex_cmds, curr))
    else
      true ->
        {val, :loop}

      nil ->
        total_cmds = Enum.count(cmds)

        case curr do
          ^total_cmds -> {val, :finish}
          _ -> {val, :oob}
        end
    end
  end

  def exec_cmd({:nop, _}, curr, val), do: {curr + 1, val}
  def exec_cmd({:acc, cmd_val}, curr, val), do: {curr + 1, val + cmd_val}
  def exec_cmd({:jmp, cmd_val}, curr, val), do: {curr + cmd_val, val}

  defp ingest_cmds() do
    System.argv()
    |> File.stream!()
    |> Enum.map(&parse_cmd/1)
  end

  defp parse_cmd(ln) do
    with [cmd, val] <- ln |> String.trim() |> String.split(" "),
         {intVal, _} <- Integer.parse(val) do
      {String.to_atom(cmd), intVal}
    end
  end
end

IO.puts("First part: #{Solver.part1()}")
IO.puts("Second part: #{Solver.part2()}")
