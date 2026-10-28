class_name LevelSelect
extends Control

const NODE:PackedScene = preload("res://new_scenes/level_select_node.tscn")

const NORMAL_NODE_TYPES:int = 5
enum NodeType { RANDOM_ENCOUNTER, TREASURE_CHEST, SMALL_MONSTER, ELITE_MONSTER, CAMPFIRE, FINAL_BOSS }

static var map:LevelSelectMap
## Array[Array[LevelSelectNode]]
## each layer is an array
var nodes:Array[Array]
@export var layer_spreadness = 115
@export var individual_node_dis = 150
const NODE_SIZE:Vector2 = Vector2(100, 120)

func _ready() -> void:
	if !map: map = LevelSelectMap.generate_map()
	build_map()

func build_map() -> void:
	var node_position:Vector2 = Vector2.ZERO
	var reachable_nodes:Array[Vector2i] = []
	for layer in LevelSelectMap.LAYERS:
		var layer_nodes:Array[LevelSelectNode] = []
		node_position.x = (1-map.nodes[layer])*NODE_SIZE.x/2
		for index in map.nodes[layer]:
			var node:LevelSelectNode = NODE.instantiate()
			node.index = Vector2i(layer, index)
			node.type = map.node_types[layer][index]
			node.position = node_position
			node_position.x += NODE_SIZE.x
			layer_nodes.append(node)
			$"map".add_child(node)
			if layer == LevelSelectMap.LAYERS-1:
				if Globals.level == Vector2i(-1,-1): node.make_selectable()
				reachable_nodes.append(node.index)
		node_position.y += NODE_SIZE.y
		nodes.append(layer_nodes)
	for layer in LevelSelectMap.LAYERS-1:
		var layer_connections:Array[Vector2i] = map.connections[layer]
		var prev_layer_nodes:Array[LevelSelectNode] = nodes[layer]
		var layer_nodes:Array[LevelSelectNode] = nodes[layer+1]
		for connection in layer_connections:
			layer_nodes[connection.y].next_levels.append(prev_layer_nodes[connection.x])
			reachable_nodes.append(Vector2i(layer, connection.x))
			if Globals.level == layer_nodes[connection.y].index:
				prev_layer_nodes[connection.x].make_selectable()
	for layer in LevelSelectMap.LAYERS:
		for index in map.nodes[layer]:
			if Vector2i(layer, index) not in reachable_nodes: nodes[layer][index].queue_free()
