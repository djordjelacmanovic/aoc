defmodule Solution do
  def first() do
    {m_time, shuttles} = read()

    Stream.iterate(m_time, &(&1 + 1))
    |> Stream.map(fn time -> {time, shuttles |> Enum.find(&(rem(time, &1) == 0))} end)
    |> Stream.filter(fn {_, sid} -> !!sid end)
    |> Enum.at(0)
    |> (fn {depart_t, sid} -> (depart_t - m_time) * sid end).()
  end

  def second() do
    {_, shuttles} = read(false)

    shuttles
    |> Enum.with_index()
    |> Enum.filter(fn {e, _} -> !!e end)
    |> iterate()
  end

  defp iterate(shuttles, num \\ 100_000_000_000_000, incr \\ 1)
  defp iterate([], num, incr), do: num - incr

  defp iterate(shuttles = [{ss, i} | rest], num, incr) do
    case rem(num + i, ss) do
      0 -> iterate(rest, num + incr * ss, incr * ss)
      _ -> iterate(shuttles, num + incr, incr)
    end
  end

  defp read(reject_x \\ true) do
    System.argv()
    |> File.read!()
    |> String.split("\n", trim: true)
    |> (fn [m_time, sids] ->
          {
            String.to_integer(m_time),
            sids
            |> String.split(",", trim: true)
            |> Enum.reject(&(reject_x && &1 == "x"))
            |> Enum.map(fn
              "x" -> nil
              s -> String.to_integer(s)
            end)
          }
        end).()
  end
end

IO.puts("First part: #{Solution.first()}")
IO.puts("Second part: #{Solution.second()}")
