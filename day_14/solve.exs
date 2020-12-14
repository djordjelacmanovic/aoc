defmodule Solution do
  def part1() do
    read()
    |> process()
    |> Map.values()
    |> Enum.sum()
  end

  def part2() do
    read()
    |> process(&write_masked_addr/4, &nop_dec/2)
    |> Map.values()
    |> Enum.sum()
  end

  defp read() do
    System.argv()
    |> File.stream!()
    |> Enum.map(&String.trim/1)
  end

  defp process(
         instr,
         addr_write \\ &write_one_addr/4,
         value_dec \\ &decode_value/2,
         mask \\ nil,
         mem \\ %{}
       )

  defp process([], _, _, _, mem), do: mem

  defp process(["mask = " <> mask | rest], addr_write, value_dec, _mask, mem),
    do: process(rest, addr_write, value_dec, to_charlist(mask), mem)

  defp process(["mem[" <> rest_instr | rest], addr_write, value_dec, mask, mem) do
    [addr, value] = String.split(rest_instr, "] = ", trim: true)

    value = value_dec.(value, mask)

    process(rest, addr_write, value_dec, mask, addr_write.(mem, addr, value, mask))
  end

  defp nop_dec(val, _), do: String.to_integer(val)

  defp decode_value(value, mask) do
    value
    |> merge(mask)
    |> Enum.map(fn
      # 88 is charval of  X
      {vb, 88} -> vb
      {_, mb} -> mb
    end)
    |> to_string()
    |> String.to_integer(2)
  end

  defp write_one_addr(mem, addr, val, _), do: Map.put(mem, addr |> String.to_integer(), val)

  defp write_masked_addr(mem, addr, val, mask) do
    addr
    |> merge(mask)
    |> Enum.reduce([], fn
      {_, 88}, [] -> ['0', '1']
      {vb, mb}, [] when mb == hd('0') -> [[vb]]
      {_, mb}, [] when mb == hd('1') -> [[mb]]
      {_, 88}, combs -> Enum.flat_map(combs, fn c -> [c ++ '0', c ++ '1'] end)
      {vb, mb}, combs when mb == hd('0') -> Enum.map(combs, fn c -> c ++ [vb] end)
      {_, mb}, combs when mb == hd('1') -> Enum.map(combs, fn c -> c ++ [mb] end)
    end)
    |> Enum.map(&(to_string(&1) |> String.to_integer(2)))
    |> Enum.reduce(mem, fn addr, mem -> Map.put(mem, addr, val) end)
  end

  defp merge(val, mask) do
    val
    |> String.to_integer()
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
    |> to_charlist()
    |> Enum.zip(mask)
  end
end

IO.puts("First part: #{Solution.part1()}")
IO.puts("Second part: #{Solution.part2()}")
