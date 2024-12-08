# internal API goes up here
P1FAKE = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
P2FAKE = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

def mulcher (str)
  str.scan(/mul\((\d{1,3}),(\d{1,3})\)/).sum do |(x, y)|
    x.to_i * y.to_i
  end
end

#external API goes down here
module Solutions
  def self.p1
    raw = TEST == "fake" ? P1FAKE : Tools::autoraw
    p("sum: #{mulcher(raw.chomp)}")
  end

  def self.p2
    raw = "do()" + (TEST == "fake" ? P2FAKE : Tools::autoraw)
    commands = /(mul\(\d{1,3},\d{1,3}\))|(do\(\))|(don't\(\))/
    on = true
    parsed = raw.scan(commands).flatten.select do |i|
      on = true if i == "do()"
      on = false if i == "don't()"
      on
    end
    p mulcher(parsed.join)
  end
end
