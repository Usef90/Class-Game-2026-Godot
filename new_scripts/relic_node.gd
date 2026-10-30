class_name RelicNode
extends TextureRect

var data:RelicData

static func create(_data:RelicData) -> RelicNode:
	var relic:RelicNode = preload("res://new_scenes/relic.tscn").instantiate()
	relic.data = _data
	return relic

func _ready() -> void:
	texture = data.image

