extends Control

const battle_button_instances = preload("res://new_scripts/temp/small_bad_guy.tscn")
var ending_node: Button 

var all_button = []

@export var layers: int = 5
@export var layer_spreadness = 115
@export var individual_node_dis = 200
@export var max_num_button_per_node: int = 4

var new_scene: PackedScene

func _ready() -> void:
	print("getting started")
	if ResourceLoader.exists("res://new_scripts/temp/run.tscn"):
		$map.queue_free()
		new_scene = load("res://new_scripts/temp/run.tscn")
		var map = new_scene.instantiate()
		map.name = "map"
		add_child(map, true)
		ending_node = get_node("map/big bad guy")
		_draw_lines()
	else:
		ending_node = $"map/big bad guy"
		_generate_thing()
		_draw_lines()
		
	
	
	
	
	
func _draw_lines() -> void:
	for node in $map.get_children():
		node._connecting()
	
	
func _generate_thing():
	var current_depth = 0
	var current_width = 0
	
	for i in range(1, layers + 1):
		var current_layer_buttons = []
		var num_node_this_layer = randi_range(1, max_num_button_per_node)
		var current_empty_space = randi_range(0, 1)
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
				
				button.position = Vector2(j * individual_node_dis + (ending_node.position.x - (current_width / 2)), current_depth + 67)
				current_layer_buttons.append(button)
				
				$map.add_child(button, true)
				button.owner = $map
				if i == layers:
					Globals.level.append(button.name)
				if all_button.is_empty():
					button.next_level.append(ending_node.name)
				else:
					var available_targets = []
					for k in all_button:
						available_targets += k
					var max_connections = randi_range(1, 2)
					
					for lines in range(max_connections):
						if available_targets.is_empty():
							break
						var closest = find_closest_node_by_x(button, available_targets)
						if closest:
							button.next_level.append(closest.name)
							available_targets.erase(closest) 
					
		all_button.append(current_layer_buttons)
		
	new_scene = PackedScene.new()
	new_scene.pack($map)
	ResourceSaver.save(new_scene,"res://new_scripts/temp/run.tscn")
	

func find_closest_node_by_x(current_node, list_of_nodes):
	var closest_distance: float = INF
	var best: Button = null
	for node in list_of_nodes:
		var current_distance = node.position.distance_squared_to(current_node.position)
		if current_distance < closest_distance:
			closest_distance = current_distance
			best = node
			
	return best
	
