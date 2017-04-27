require_relative 'graph.rb'

graph = Graph.new.maze_to_graph(Dir.glob("../mazes/").sample)