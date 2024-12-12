# internal API goes up here
def munge(raw = Tools::autofetch)
  raw.map { |line| line.split(/:?\s+/).map(&:to_i) }
end

def parse(tests, ops)
  tests.select do |(res, start, *rest)|
    out = rest.reduce([start]) do |a, n|
      a.flat_map { |v| ops.map { |o| o.call(v, n) } }
    end
    out.include? res
  end
end

#external API goes down here
module Solutions
  P = -> (a, b) { a + b }
  M = -> (a, b) { a * b }
  C = -> (a, b) { "#{a}#{b}".to_i }

  def self.p1
    n = parse(munge, [P, M])
    pp n.sum(&:first)
  end

  def self.p2
    n = parse(munge, [P, M, C])
    pp n.sum(&:first)
  end
end
