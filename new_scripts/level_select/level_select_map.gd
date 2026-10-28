class_name LevelSelectMap
extends Resource

const MIN_NODES_PER_LAYER:int = 3
const MAX_NODES_PER_LAYER:int = 5
const SECONDARY_CONNECTION_CHANCE:int = 2
const LAYERS: int = 5
## nodes in each layer
@export var nodes:Array[int] = []
## Array[Array[NodeType]]
## each layer is an array
@export var node_types:Array[Array] = []
## Array[Array[Vector2i]]
## each layer is an array
## the x is the index of the lower layer; the y is the index of the higher layer
@export var connections:Array[Array] = []

static func generate_map() -> LevelSelectMap:
	var map:LevelSelectMap = LevelSelectMap.new()
	var layer_nodes := 3
	for layer in LAYERS:
		var layer_node_types:Array[LevelSelect.NodeType] = []
		var layer_connections:Array[Vector2i] = []
		if layer == 0: # special case for first layer
			if layer == 0: layer_node_types.append(LevelSelect.NodeType.FINAL_BOSS)
			map.nodes.append(1)
		else:
			for node in layer_nodes:
				layer_node_types.append(randi_range(0, LevelSelect.NORMAL_NODE_TYPES-1))
			# generate connections
			var previous_nodes:Array[LevelSelect.NodeType] = map.node_types[layer-1]
			var nodes_diff:int = len(previous_nodes) - layer_nodes
			if layer == 1: # previous layer was 0
				for node in layer_nodes:
					layer_connections.append(Vector2i(0, node))
			elif nodes_diff == 0: # same amount of nodes in previous layer
				for node in layer_nodes:
					layer_connections.append(Vector2i(node, node))
					if randi_range(1,SECONDARY_CONNECTION_CHANCE) == 1:
						if node == 0: layer_connections.append(Vector2i(1, node))
						elif node == layer_nodes-1: layer_connections.append(Vector2i(layer_nodes-2, node))
						else: layer_connections.append(Vector2i(node+(1 if randi_range(0,1) else -1), node))
			elif nodes_diff > 0: # more nodes in previous layer
				for node in layer_nodes:
					var primary_connection:int
					if node == 0: primary_connection = 0
					elif node == layer_nodes-1: primary_connection = 1
					else: primary_connection = randi_range(0,1)
					layer_connections.append(Vector2i(node+primary_connection, node))
					if randi_range(1,SECONDARY_CONNECTION_CHANCE) == 1:
						layer_connections.append(Vector2i(node+1-primary_connection, node))
			else: # less codes in previous layer
				for node in layer_nodes:
					var primary_connection:int
					if node == 0: primary_connection = 0
					elif node == layer_nodes-1: primary_connection = -1
					else:
						primary_connection = randi_range(-1,0)
						if randi_range(1,SECONDARY_CONNECTION_CHANCE) == 1:
							layer_connections.append(Vector2i(node-1-primary_connection, node))
					layer_connections.append(Vector2i(node+primary_connection, node))
			map.nodes.append(layer_nodes)
			map.connections.append(layer_connections)
		map.node_types.append(layer_node_types)
		if randi_range(0,1) and layer_nodes < MAX_NODES_PER_LAYER:
			layer_nodes += 1
		elif layer_nodes > MIN_NODES_PER_LAYER:
			layer_nodes -= 1
	return map

