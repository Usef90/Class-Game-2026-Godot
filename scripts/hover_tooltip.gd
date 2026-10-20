extends CanvasLayer

## Kallum coded but this is the shop item viewer
## so I don't know it mostly does

@onready var panel:TooltipPanel = preload("res://new_scenes/tooltip_panel.tscn").instantiate()
var targets:Array[Control] = []
var tween:Tween

const POP_DURATION := 0.12
const GAP_FROM_TARGET := 14.0

func _ready() -> void:
	#add_child(panel)
	pass

func setup(target:Control, title_text:String, desc_text:String) -> void:
	target.mouse_entered.connect(func():show_at(target, title_text, desc_text))
	target.mouse_exited.connect(func(): HoverTooltip.hide_tooltip(target))

func show_at(target: Control, title_text: String, desc_text: String) -> void:
	if target not in targets:
		targets.append(target)
	panel.title_label.text = title_text
	panel.desc_label.visible = desc_text.strip_edges() != ""
	panel.desc_label.text = desc_text

	panel.visible = true
	panel.modulate.a = 0.0
	panel.scale = Vector2(0.85, 0.85)

	_reposition(target)
	if tween: tween.kill()
	tween = create_tween()
	tween.set_parallel(true) \
		.tween_property(panel, "modulate:a", 1.0, POP_DURATION) \
		.tween_property(panel, "scale", Vector2.ONE, POP_DURATION) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func hide_tooltip(target: Control) -> void:
	if target not in targets:
		targets.erase(target)
	
	if len(targets) == 0:
		if tween: tween.kill()
		panel.visible = false

func _reposition(target: Control) -> void:
	var target_rect := target.get_global_rect()
	var panel_size := panel.size
	panel.pivot_offset = panel_size * 0.5

	var pos := Vector2(
		target_rect.position.x + target_rect.size.x * 0.5 - panel_size.x * 0.5,
		target_rect.position.y - panel_size.y - GAP_FROM_TARGET
	)

	var viewport_size := get_viewport().get_visible_rect().size
	pos.x = clamp(pos.x, 8.0, max(8.0, viewport_size.x - panel_size.x - 8.0))
	if pos.y < 8.0:
		# Not enough room above -- show below the card instead.
		pos.y = target_rect.position.y + target_rect.size.y + GAP_FROM_TARGET

	panel.position = pos
