extends Node

## dialogue event 
## if the num of turns == at_when it starts the dialogue

@export var at_when:int = 0 #in turns if it isn't obvious
@export var dialogues: Array[DialogueEntry] = []
@onready var battle:Battle = $"/root/battle"

var finished = false

func _process(_delta: float) -> void:
	if battle.current_turn == at_when:
		Events.emit_signal("dialogue", dialogues)
		
		battle.current_turn -= 1
		queue_free()
		
