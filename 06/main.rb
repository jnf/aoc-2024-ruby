# internal API goes up here
class Mapper
  U = '^'; L = '<'; R = '>'; D = 'V'
  TURNS = [U, R, D, L]

  attr_reader :grid, :pos, :dir, :mov, :tracks

  def initialize(grid)
    @tracks = Hash.new { |h, k| h[k] = Set.new }
    @grid = grid
    @pos = initial_pos
    @dir = '^'
    @mov = {
      "#{U}" => [-1, 0], "#{R}" => [0, 1],
      "#{D}" => [1, 0],  "#{L}" => [0, -1],
    }
  end

  def patrol
    loop do
      oy, ox = pos
      dy, dx = mov[dir]
      ny, nx = [oy + dy, ox + dx]
      break unless ny >= 0 && nx >= 0 && grid[ny] && grid[ny][nx]
      if grid[ny][nx] == '#'
        turn
      else
        move(ny, nx)
      end
    end
  end

  def infinite_patrol?
    loop do
      oy, ox = pos
      dy, dx = mov[dir]
      ny, nx = [oy + dy, ox + dx]
      break unless ny >= 0 && nx >= 0 && grid[ny] && grid[ny][nx]
      return true if tracks[dir].include?([ny, nx])
      if grid[ny][nx] == '#'
        turn
      else
        move(ny, nx)
      end
    end
    false
  end

  def move(ny ,nx)
    @grid[ny][nx] = 'ׂׂ⊙'
    @pos = [ny, nx]
    @tracks[dir] << pos
  end

  def turn
    @dir = TURNS[(TURNS.find_index(dir) + 1)] || TURNS[0]
  end

  private
  def initial_pos
    x, y = [nil, nil]
    y = grid.find_index { |r| r.include?(U) }
    [y, grid[y].find_index { |c| c == U }]
  end
end

#external API goes down here
module Solutions
  def self.p1
    m = Mapper.new(Tools::autogrid)
    m.patrol
    pp m.grid.flatten.reduce({}) { |a, v| a[v] ||= 0; a[v] += 1; a }
  end

  def self.p2
    base_grid = Tools::autogrid
    m = Mapper.new(base_grid.map(&:dup))
    m.patrol
    trod = m.tracks.values.reduce(Set.new) { |a, s| a.merge(s) }
    
    inf = trod.count do |(ty, tx)|
      ng = base_grid.map(&:dup)
      n = Mapper.new(ng)
      n.grid[ty][tx] = '#' unless n.pos == [ty,tx]
      inf = n.infinite_patrol?
    end
    pp ({inf:, tried: trod.count })
  end
end
