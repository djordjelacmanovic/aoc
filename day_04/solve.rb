FILE = ARGV[0] || "./test"

REQUIRED_FIELDS = {
  "byr" => /^19[2-9]\d|200[012]$/,
  "iyr" => /^201\d|2020$/,
  "eyr" => /^202\d|2030$/,
  "hgt" => /(^((59)|(6\d)|(7[0-6]))(?:in)$)|(^((1[5-8]\d)|(19[0-3]))(?:cm)$)/,
  "hcl" => /^#[0-9a-f]{6}$/,
  "ecl" => /^amb|blu|brn|gry|grn|hzl|oth$/,
  "pid" => /^\d{9}$/,
}

def run(validate_fields = false)
  curr_required_fields = []
  valid_passports = 0

  File.foreach(FILE) do |line|
    line.strip!
    if line.empty?
      valid_passports += REQUIRED_FIELDS.length == curr_required_fields.length ? 1 : 0
      curr_required_fields = []
      next
    end
    curr_required_fields += line.split(" ").map { |l| l.strip.split(":") }.reject { |f,v| f == 'cid' || (validate_fields && !REQUIRED_FIELDS[f].match?(v)) }.map { |f, v| f }
  end

  # last line not empty
  valid_passports += REQUIRED_FIELDS.length == curr_required_fields.length ? 1 : 0

  valid_passports
end

puts "First part (no value validation): #{run}"
puts "Second part (values validated): #{run(true)}"
