require "SecureRandom"
require "chunky_png"

class Graph

	attr_reader :nodes, :start, :end

	def initialize()
		@nodes = []
		@start = @end = nil
	end

	def add_node(*connenctions)
		new_node = Node.new
		@nodes << new_node

		if connenctions.size > 0
			connenctions.each do |node, weight|
				if @nodes.include? node
					add_edge(node, new_node, weight)
				else
					extra_node = add_node()
					add_edge(new_node, extra_node, weight)
				end
			end
		end

		return new_node
	end

	def remove_node(node)
		@nodes.delete(node)
	end

	def add_edge(node1, node2, weight)
		node1.add_connection(node2, weight)
		node2.add_connection(node1, weight)
		return nil
	end

	def maze_to_graph(path)
		white = 4294967295

		png = ChunkyPNG::Image.from_file(path)
		maze = png.pixels.each_slice(png.width).to_a

		maze.each_with_index do |row, i|
			row.each_with_index do |color, j|
				if color == white
					node = add_node()
					maze[i][j] = node

					neighbors = []
					neighbors << [i-1, j] if i > 0 and maze[i-1][j].class.to_s == "Node"
					neighbors << [i, j-1] if j > 0 and maze[i][j-1].class.to_s == "Node"


					neighbors.each do |neighbor|
						neighbor = maze[neighbor[0]][neighbor[1]]
						add_edge(node, neighbor, 1) if neighbor.class.to_s == "Node"
					end

					if i == 0 or j == 0
						@start = node
					elsif i == png.height - 1 or j == png.width - 1
						@end = node
					end
				end
			end
		end

		simplify_graph

		return nil

	end

	def simplify_graph
		double_nodes = @nodes.select{|node| node.connenctions.size == 2}

		while double_nodes.size > 0
			node = double_nodes[0]

			node1 = node.connenctions.keys[0]
			node2 = node.connenctions.keys[1]
			weight = node.connenctions.values.inject(:+)

			add_edge(node1, node2, weight)
			node1.connenctions.delete(node)
			node2.connenctions.delete(node)
			remove_node(node)

			double_nodes = @nodes.select{|node| node.connenctions.size == 2}
		end

		puts @nodes.size
		puts double_nodes.size
		puts
	end

	def to_s()
		puts @nodes
	end

end

class Node

	attr_reader :id
	attr_accessor :connenctions

	def initialize()
		@id = SecureRandom.uuid
		@connenctions = {}
	end

	def add_connection(node, weight)
		@connenctions[node] = weight
		return self
	end

	def to_s()
		puts @id
	end

end


# graph = Graph.new()
# node1 = graph.add_node()
# puts node1
# node2 = graph.add_node({node1 => 4 })
# puts
# puts node1
# puts node2
