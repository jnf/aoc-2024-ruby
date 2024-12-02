# internal API goes up here
def munge(raw)
  raw.map { |line| line.split(/\s+/).map(&:to_i) }
end

#external API goes down here
module Solutions
  def self.p1
    reports = munge(Tools::autofetch)
    safe, unsafe = reports.partition do |report|
      next false if report[0] == report[1]
      comp = report[0] < report[1] ? :< : :>
      report.each_cons(2).all? do |(x, y)|
        d = (x-y).abs
        x.send(comp, y) && d >= 1 && d <= 3
      end
    end
    p ({ safe: safe.count, unsafe: unsafe.count })
  end

  def self.p2
    reports = munge(Tools::autofetch)
    safe, unsafe = reports.partition do |report|
      next false if report[0] == report[1]
      comp = report[0] < report[1] ? :< : :>
      report.each_cons(2).all? do |(x, y)|
        d = (x-y).abs
        x.send(comp, y) && d >= 1 && d <= 3
      end
    end
    p ({ safe: safe.count, unsafe: unsafe.count })
  end
end
