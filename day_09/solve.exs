defmodule Solver do
  def part1() do
    {sol, _} =
      read()
      |> find_first_matching(
        System.argv() |> Enum.at(1) |> String.to_integer(),
        &if not contains_sum_of?(&1, &2) do
          :done
        else
          :next
        end
      )

    sol
  end

  def part2() do
    target_num = Solver.part1()

    {_, seq} =
      read()
      |> find_first_matching(2, fn seq, _ ->
        cond do
          Enum.sum(seq) == target_num -> :done
          Enum.sum(seq) < target_num -> :extend
          Enum.sum(seq) > target_num -> :shift
        end
      end)

    Enum.min(seq) + Enum.max(seq)
  end

  def find_first_matching(nums, preamble_len, matcher_fn, preamble \\ [])

  def find_first_matching([head | rest], preamble_len, matcher_fn, preamble)
      when length(preamble) < preamble_len,
      do: find_first_matching(rest, preamble_len, matcher_fn, preamble ++ [head])

  def find_first_matching(
        nums = [head | rest],
        preamble_len,
        matcher_fn,
        preamble = [_phead | prest]
      ) do
    case matcher_fn.(preamble, head) do
      :done -> {head, preamble}
      :extend -> find_first_matching(rest, preamble_len, matcher_fn, preamble ++ [head])
      :shift -> find_first_matching(nums, preamble_len, matcher_fn, prest)
      :next -> find_first_matching(rest, preamble_len, matcher_fn, prest ++ [head])
    end
  end

  defp contains_sum_of?(nums, target, prev_nums \\ %{})
  defp contains_sum_of?([], _target, _prev_nums), do: false

  defp contains_sum_of?([h | r], target, prev_nums) do
    case prev_nums[target - h] do
      nil -> contains_sum_of?(r, target, Map.put(prev_nums, h, true))
      _ -> true
    end
  end

  defp read() do
    System.argv()
    |> List.first()
    |> File.stream!()
    |> Enum.map(&String.to_integer(String.trim(&1)))
  end
end

IO.puts("First part: #{Solver.part1()}")
IO.puts("Second part: #{Solver.part2()}")
