module Part1
  def self.solve
    num1, num2 = find_nums(File.readlines("./input"), 2020)
    puts "Answer is #{num1 * num2}"
  end

  def self.find_nums(lines, sum)
    prev = {}
    lines.each do |line|
      num = line.to_i
      next if num > sum
      if prev[sum - num]
        return [sum - num, num]
      end
      prev[num] = true
    end
    return false
  end
end

module Part2
  def self.solve
    lines = File.readlines("./input")
    lines.each do |line|
      num = line.to_i
      next if num > 2020
      res = Part1.find_nums(lines, 2020 - num)
      next if !res
      return puts "Answer is #{num * res[0] * res[1] }"
    end
  end
end

Part1.solve
Part2.solve
