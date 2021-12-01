valid_field? = fn
  "byr:" <> _, false ->
    true

  "iyr:" <> _, false ->
    true

  "eyr:" <> _, false ->
    true

  "hgt:" <> _, false ->
    true

  "hcl:" <> _, false ->
    true

  "ecl:" <> _, false ->
    true

  "pid:" <> _, false ->
    true

  "byr:" <> val, true ->
    Regex.match?(~r/^19[2-9]\d|200[012]$/, val)

  "iyr:" <> val, true ->
    Regex.match?(~r/^201\d|2020$/, val)

  "eyr:" <> val, true ->
    Regex.match?(~r/^202\d|2030$/, val)

  "hgt:" <> val, true ->
    Regex.match?(~r/(^((59)|(6\d)|(7[0-6]))(?:in)$)|(^((1[5-8]\d)|(19[0-3]))(?:cm)$)/, val)

  "hcl:" <> val, true ->
    Regex.match?(~r/^#[0-9a-f]{6}$/, val)

  "ecl:" <> val, true ->
    Regex.match?(~r/^amb|blu|brn|gry|grn|hzl|oth$/, val)

  "pid:" <> val, true ->
    Regex.match?(~r/^\d{9}$/, val)

  _, _ ->
    false
end

cond_inc = fn
  v, 7 -> v + 1
  v, _ -> v
end

solve = fn validate_values ->
  {r, f} =
    File.stream!("./input")
    |> Enum.map(&(String.trim(&1) |> String.split(" ", trim: true)))
    |> Enum.reduce({0, 0}, fn
      [], {c, f} ->
        {cond_inc.(c, f), 0}

      fields, {c, f} ->
        {c, f + Enum.count(fields, &valid_field?.(&1, validate_values))}
    end)

  cond_inc.(r, f)
end

IO.puts("First part: #{solve.(false)}")
IO.puts("Second part: #{solve.(true)}")
