# internal API goes up here
class Noder
  attr_reader :grid, :xrange, :yrange, :nodes, :antinodes
  def initialize(grid)
    @grid = grid
    @xrange = (0...grid.first.count)
    @yrange = (0...grid.count)
    @nodes = build_node_map # map of symbol => Set([coordinates])
    @antinodes = Set.new # list of [y, x]
  end

  def find_antinodes(expand = false)
    nodes.values.each do |cs|
      cs.to_a.combination(2).each do |((y1, x1), (y2, x2))|
        dy = y1 - y2; dx = x1 - x2
        n = 1
        loop do
          ny = dy * n
          nx = dx * n
          @antinodes << [y1 + ny, x1 + nx] if on_grid?(y1 + ny, x1 + nx)
          @antinodes << [y2 - ny, x2 - nx] if on_grid?(y2 - ny, x2 - nx)
          break unless expand && (on_grid?(y1 + ny, x1 + nx) || on_grid?(y2 - ny, x2 - nx))
          n += 1
        end
      end
    end
  end

  private
  def build_node_map
    grid.each_with_index.reduce(Hash.new { |h, k| h[k] = Set.new }) do |a, (r, y)|
      r.each_with_index { |v, x| a[v] << [y, x] unless v == '.' }
      a
    end
  end

  def on_grid?(y, x)
    yrange === y && xrange === x
  end
end

#external API goes down here
module Solutions
  def self.p1
    n = Noder.new(Tools::autogrid)
    n.find_antinodes
    p n.antinodes.count
  end

  def self.p2
    n = Noder.new(Tools::autogrid)
    n.find_antinodes(true)
    p (n.antinodes + n.nodes.values.reduce(&:+)).count
  end
end
