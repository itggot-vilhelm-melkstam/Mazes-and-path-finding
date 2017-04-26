require 'chunky_png'

def generate

  @cols = ARGV[0].to_i
  @rows = ARGV[1].to_i

  @maze = ChunkyPNG::Image.new(@cols * 2 + 1, @rows * 2 + 1, ChunkyPNG::Color("black"))
  @cells = Array.new(@cols) {Array.new(@rows, false)}
  stack = []

  current = [0, 0]
  @cells[0][0] = true
  @maze[current[0] * 2 + 1, current[1] * 2 + 1] = ChunkyPNG::Color("white")

  while @cells.flatten.include? false do
    neighbors = neighbors(current)
    if neighbors
      chosen = neighbors.sample
      stack.push current
      remove_wall(current, chosen)
      current = chosen
      @cells[chosen[0]][chosen[1]] = true
      @maze[chosen[0] * 2 + 1, chosen[1] * 2 + 1] = ChunkyPNG::Color("white")
    else
      current = stack.pop
    end
  end

  @maze[0, 1] = ChunkyPNG::Color("white")
  @maze[@cols * 2, @rows * 2 - 1] = ChunkyPNG::Color("white")
  @maze.save("../mazes/#{@cols}x#{@rows} - recursive backtracker - ruby.png")
end

def neighbors(curr)
  x, y = curr[0], curr[1]
  neighbors = []

  neighbors << [x - 1, y] if x > 0 and @cells[x - 1][y] == false
  neighbors << [x + 1, y] if x < @cols - 1 and @cells[x + 1][y] == false
  neighbors << [x, y - 1] if y > 0 and @cells[x][y - 1] == false
  neighbors << [x, y + 1] if y < @rows and @cells[x][y + 1] == false

  neighbors.empty? ? nil : neighbors

end

def remove_wall(curr, chos)
  if curr[0] - chos[0] == 1
    @maze[curr[0] * 2, curr[1] * 2 + 1] = ChunkyPNG::Color("white")
  elsif curr[0] - chos[0] == -1
    @maze[chos[0] * 2, curr[1] * 2 + 1] = ChunkyPNG::Color("white")
  elsif curr[1] - chos[1] == 1
    @maze[curr[0] * 2 + 1, curr[1] * 2] = ChunkyPNG::Color("white")
  elsif curr[1] - chos[1] == -1
    @maze[curr[0] * 2 + 1, chos[1] * 2] = ChunkyPNG::Color("white")
  end

end

generate
