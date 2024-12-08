# internal API goes up here
class GridSearch
  attr_reader :grid, :y, :x

  def initialize (grid)
    @grid = grid
  end

  def locate (y, x)
    @y = y
    @x = x
  end

  def searchers
    @_searchers ||= GridSearch.instance_methods(false).select { |m| m =~ /^to_the_/ }
  end

  def to_the_right
    [grid[y][x],grid[y][x+1],grid[y][x+2],grid[y][x+3]].join
  end

  def to_the_left
    return '' if x - 3 < 0
    [grid[y][x],grid[y][x-1],grid[y][x-2],grid[y][x-3]].join
  end

  def to_the_up
    return '' if y - 3 < 0
    [grid[y][x],grid[y-1][x],grid[y-2][x],grid[y-3][x]].join
  end

  def to_the_down
    return '' if y + 3 > grid.count - 1
    [grid[y][x],grid[y+1][x],grid[y+2][x],grid[y+3][x]].join
  end

  def to_the_up_left
    return '' if y - 3 < 0 || x - 3 < 0
    [grid[y][x],grid[y-1][x-1],grid[y-2][x-2],grid[y-3][x-3]].join
  end

  def to_the_up_right
    return '' if y - 3 < 0
    [grid[y][x],grid[y-1][x+1],grid[y-2][x+2],grid[y-3][x+3]].join
  end

  def to_the_down_left
    return '' if y + 3 > grid.count - 1 || x - 3 < 0
    [grid[y][x],grid[y+1][x-1],grid[y+2][x-2],grid[y+3][x-3]].join
  end

  def to_the_down_right
    return '' if y + 3 > grid.count - 1
    [grid[y][x],grid[y+1][x+1],grid[y+2][x+2],grid[y+3][x+3]].join
  end
end

#external API goes down here
module Solutions
  def self.p1
    gs = GridSearch.new(Tools::autogrid)
    xs = gs.grid.each_with_index.reduce([]) do |a, (r, ri)|
      r.each_with_index { |c, ci| a << [ri, ci] if c == 'X' }
      a
    end
    q = xs.flat_map do |(y, x)|
      gs.locate(y, x)
      gs.searchers.map { |s| gs.send(s) }
    end.select { |v| v == "XMAS" }
    pp q.count
  end

  def self.p2
    grid = Tools::autogrid
    as = grid.each_with_index.reduce([]) do |a, (r, ri)|
      r.each_with_index { |c, ci| a << [ri, ci] if c == 'A' }
      a
    end
    z = as.select do |(y, x)|
      next false if y < 1 || y >= grid.count - 1 || x == 0
      x1 = "#{grid[y-1][x-1]}#{grid[y+1][x+1]}"
      x2 = "#{grid[y-1][x+1]}#{grid[y+1][x-1]}"
      (x1 == "MS" || x1 == "SM") && (x2 == "MS" || x2 == "SM")
    end
    pp z.count
  end
end
