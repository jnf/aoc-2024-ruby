# internal API goes up here
def munge
  rules, updates = Tools::autoraw.split(/\n\n/).map { |s| s.split(/\n/) }
  [parse_rules(rules), parse_updates(updates)]
end

def parse_rules(rr)
  rr.reduce(Hash.new { |h, k| h[k] = [] }) do |a, raw|
    k, v = raw.split('|').map(&:to_i)
    a[k] << v
    a
  end
end

def parse_updates(ru)
  ru.map { |r| r.split(',').map(&:to_i).reverse }
end

def sorted(rules, updates)
  updates.partition do |update|
    update.each_with_index.all? do |u, i|
      after = update.slice(...i)
      (after - rules[u]).empty?
    end
  end
end

#external API goes down here
module Solutions
  def self.p1
    rules, updates = munge
    pp sorted(rules, updates).first.sum { |v| v[v.count/2] }
  end

  def self.p2
    rules, updates = munge
    _, unordered = sorted(rules, updates)
    fixed = unordered.map { |u| u.sort { |a, b| rules[b].include?(a) ? 1 : -1 } }
    pp fixed.sum { |v| v[v.count/2] }
  end
end
