require_relative 'graph.rb'

graph = Graph.new
graph.maze_to_graph(Dir.glob("../mazes/100x100 - recursive backtracker - ruby.png").sample)

def dijkstra(graph, start, end)
  visited = [start]


end

class DijkstraNode
