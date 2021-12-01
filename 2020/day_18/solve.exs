defmodule Solution do
  def part1() do
    read()
    |> Stream.map(&solve_expr/1)
    |> Enum.sum()
  end

  def part2() do
    read()
    |> Stream.map(&solve_expr(&1, true))
    |> Enum.sum()
  end

  defp solve_expr(expr_str, addition_first \\ false) do
    case Regex.scan(~r/(\([\s\d\+*\/]+\))/, expr_str, capture: :first) do
      [] ->
        solve_simple(expr_str, addition_first) |> String.to_integer()

      brackets ->
        brackets
        |> Enum.map(fn [m] ->
          {m, String.replace(m, ~r/[\(\)]/, "") |> solve_simple(addition_first)}
        end)
        |> Enum.reduce(expr_str, fn
          {sub_expr, val}, expr ->
            String.replace(expr, sub_expr, val |> to_string())
        end)
        |> solve_expr(addition_first)
    end
  end

  defp solve_simple(expr_str, false), do: solve_simple(expr_str, ~r/^(\d+\s+[\+*]\s+\d+)/)

  defp solve_simple(expr_str, true),
    do:
      solve_simple(expr_str, ~r/(\d+\s+\+\s+\d+)/)
      |> solve_simple(~r/(\d+\s+\*\s+\d+)/)

  defp solve_simple(expr_str, r = %Regex{}) do
    case Regex.run(r, expr_str, capture: :first) do
      nil ->
        expr_str

      [sub] ->
        String.replace(expr_str, sub, eval_to_str(sub), global: false)
        |> solve_simple(r)
    end
  end

  defp eval_to_str(str) do
    {r, _} = Code.eval_string(str)
    to_string(r)
  end

  defp read() do
    System.argv()
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end
end

IO.puts("First part: #{Solution.part1()}")
IO.puts("Second part: #{Solution.part2()}")
