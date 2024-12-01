# internal API goes up here
def munge(data)
  data.reduce([[], []]) do |a, l|
    x, y = l.split(/\s+/)
    a[0] << x.to_i
    a[1] << y.to_i
    a
  end
end

def p1(data)
  x, y = munge(data)
  x.sort.zip(y.sort).reduce(0) { |s, (a, b)| s + (a-b).abs }
end

def p2(data)
  x, y = munge(data)
  z = y.reduce(Hash.new(0)) do |a, n|
    a[n] += 1
    a
  end
  x.reduce(0) { |a, n| a += n * z[n] }
end

#external API goes down here
module Solutions
  def self.fake
    data = Tools::autofetch
    p p1(data) # 11
    p p2(data) # 31
  end

  def self.real
    data = Tools::autofetch
    p p1(data) # 1258579
    p p2(data) # 23981443
  end
end
