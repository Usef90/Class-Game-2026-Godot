extends TextureRect
class_name StatusEffectIcon

## status effect icon
## may not need to be fixed

var is_hovered: bool = false

var effect:EffectData
var value:int

func _ready() -> void:
	texture = effect.icon
	$value.text = str(value)
	$value.visible = !effect.valueless

func _on_mouse_entered() -> void:
	is_hovered = true
	Events.emit_signal("show_status_text", effect)

func _on_mouse_exited() -> void:
	is_hovered = false
	Events.emit_signal("hide_status_text")

