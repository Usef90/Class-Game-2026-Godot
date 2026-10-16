extends Control

const battle_button_instances = preload("res://new_scripts/temp/small_bad_guy.tscn")
var ending_node: Button 

var all_button = []

@export var layers: int = 5
@export var layer_spreadness = 100
@export var individual_node_dis = 100
@export var max_num_button_per_node: int = 5

var new_scene: PackedScene

func _ready() -> void:
	print("getting started")
	if ResourceLoader.exists("res://new_scripts/temp/run.tscn"):
		var old_map = $map
		remove_child(old_map)
		old_map.free()
		new_scene = load("res://new_scripts/temp/run.tscn")
		var map = new_scene.instantiate()
		map.name = "map"
		add_child(map, true)
		ending_node = get_node("map/big bad guy")
		_draw_lines()
		var real_nodes = []
		for node_name in Globals.level_current_next_levels:

			var found_node = map.get_node_or_null(node_name)
			if found_node:
				real_nodes.append(found_node)
		Globals.level_current_next_levels = real_nodes
	else:
		ending_node = $"map/big bad guy"
		_generate_thing()
		_draw_lines()
		
	print(Globals.level_current_next_levels)
	
	
	
	
func _draw_lines() -> void:
	for node in $map.get_children():
		node._connecting()
	
	
func _generate_thing():
	var current_depth = 0
	var current_width = 0
	
	all_button.clear()
	
	for i in range(1, layers + 1):
		var current_layer_buttons = []
		var num_node_this_layer = randi_range(1, max_num_button_per_node)
		var current_empty_space = randi_range(0, 3)
		var num_of_buttons = num_node_this_layer
		var num_of_spaces = current_empty_space
		current_depth += layer_spreadness
		current_width = (num_node_this_layer + current_empty_space) * layer_spreadness
		
		for j in range(num_node_this_layer + current_empty_space):
			if num_of_buttons == 0: 
				break
				
			var spawn_button = false
			if num_of_spaces != 0:
				if randi_range(0, 1) == 0:
					spawn_button = true
					num_of_buttons -= 1
				else:
					num_of_spaces -= 1
			else:
				spawn_button = true
				num_of_buttons -= 1
				
			if spawn_button:
				var button = battle_button_instances.instantiate()
				
				button.position = Vector2(j * 100 + (ending_node.position.x - (current_width / 2)), current_depth + 67)
				current_layer_buttons.append(button)
				button.layer = layers + 1 - i
				
				$map.add_child(button, true)
				button.owner = $map
				
				if all_button.is_empty():
					button.next_level_paths.append(button.get_path_to(ending_node))
				else:
					var previous_layer = all_button[-1] 
					var available_targets = previous_layer.duplicate()
					var max_connections = randi_range(1, min(3, available_targets.size()))
					
					for lines in range(max_connections):
						if available_targets.is_empty():
							break
						var closest = find_closest_node_by_x(button, available_targets)
						if closest:
							button.next_level_paths.append(button.get_path_to(closest))
							available_targets.erase(closest) 
							
				if i == layers:
						Globals.level_current_next_levels.append(button.name) 
					
		all_button.append(current_layer_buttons)
		
	new_scene = PackedScene.new()
	new_scene.pack($map)
	ResourceSaver.save(new_scene, "res://new_scripts/temp/run.tscn")

func find_closest_node_by_x(current_node, list_of_nodes):
	var closest_distance: float = INF
	var best: Button = null
	for node in list_of_nodes:
		var current_distance = node.position.distance_squared_to(current_node.position)
		if current_distance < closest_distance:
			closest_distance = current_distance
			best = node
			
	return best
	
