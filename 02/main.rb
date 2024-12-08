# internal API goes up here
def munge(raw)
  raw.map { |line| line.split(/\s+/).map(&:to_i) }
end

def gud?(x, y, comp)
  d = (x-y).abs
  x.send(comp, y) && d >= 1 && d <= 3
end

def safe?(report)
  return false if report[0] == report[1]
  comp = report[0] < report[1] ? :< : :>
  report.each_cons(2).all? { |(x, y)| gud?(x, y, comp) }
end

def safer?(report)
  cons = report.each_cons(2)
  a, b = cons.find { |(x, y)| x != y }
  comp = a < b ? :< : :>
  ui = cons.with_index.find_index { |(x ,y), i| !gud?(x, y, comp) }
  nxt1 = report.reject.with_index { |_, i| i == ui }
  nxt2 = report.reject.with_index { |_, i| i == ui+1 }
  nxt3 = report.reject.with_index { |_, i| i == ui-1 }
  safe?(nxt1) || safe?(nxt2) || safe?(nxt3)
end

#external API goes down here
module Solutions
  def self.p1
    reports = munge(Tools::autofetch)
    safe, unsafe = reports.partition { |report| safe?(report) }
    p ({ safe: safe.count, unsafe: unsafe.count })
  end

  def self.p2
    reports = munge(Tools::autofetch)
    safe, unsafe = reports.partition do |report|
      next true if safe?(report) # if we're safe, we're safe
      safer?(report)
    end
    p ({ safe: safe.count, unsafe: unsafe.count })
  end
end
