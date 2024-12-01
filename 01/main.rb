# internal API goes up here
def munge(data)
  data.reduce([[], []]) do |a, l|
    x, y = l.split(/\s+/)
    a[0] << x.to_i
    a[1] << y.to_i
    a
  end
end

#external API goes down here
module Solutions
  def self.p1
    x, y = munge(Tools::autofetch)
    p x.sort.zip(y.sort).reduce(0) { |s, (a, b)| s + (a-b).abs }
  end

  def self.p2
    x, y = munge(Tools::autofetch)
    z = y.reduce(Hash.new(0)) do |a, n|
      a[n] += 1
      a
    end
    p x.reduce(0) { |a, n| a += n * z[n] }
  end
end
