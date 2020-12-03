defmodule Solution do
  def count_valid([], _, count), do: count

  def count_valid([head | rest], validity_test, count \\ 0),
    do:
      count_valid(
        rest,
        validity_test,
        count +
          if validity_test.(head) do
            1
          else
            0
          end
      )

  def parse(str),
    do:
      Regex.named_captures(
        ~r/(?'min'\d+)(?:-)(?'max'\d+)(?:\s)(?'char'[A-Za-z])(?:: )(?'pass'\S+)$/,
        str
      )

  def has_chars_in_correct_pos?(str), do: parse(str) |> correct_positions?()

  def correct_positions?(%{"min" => min, "max" => max, "char" => char, "pass" => pass}),
    do:
      correct_positions?(
        String.at(pass, String.to_integer(min) - 1),
        String.at(pass, String.to_integer(max) - 1),
        char
      )

  def correct_positions?(f, l, c) when f == c, do: l != c
  def correct_positions?(f, l, c) when l == c, do: f != c
  def correct_positions?(_, _, _), do: false

  def is_valid?(str),
    do:
      parse(str)
      |> is_valid?(to_charlist(str))

  def is_valid?(%{"min" => min, "max" => max}, [], count),
    do: String.to_integer(min) <= count and String.to_integer(max) >= count

  def is_valid?(rules = %{"char" => char}, [fc | rest], count \\ -1),
    do:
      is_valid?(
        rules,
        rest,
        count +
          if char == to_string([fc]) do
            1
          else
            0
          end
      )
end

IO.puts("first solition")

File.read!("./input")
|> String.split("\n")
|> Solution.count_valid(&Solution.is_valid?(&1))
|> IO.puts()

IO.puts("second solution")

File.read!("./input")
|> String.split("\n")
|> Solution.count_valid(&Solution.has_chars_in_correct_pos?(&1))
|> IO.puts()
