extends Resource
class_name enemy_stats
enum actions {HEAL, DAMAGE, BUFF, DEBUFF}

@export var hitpoints: int = 20
@export var attacks: Array[actions]

@export var base_damage: int = 6

var drip: Texture2D


func _increase_damage():
	base_damage *= 1.2
	base_damage = int(base_damage)

func _choose_random_attacks():
	attacks.append(actions.DAMAGE)
	var attack_choices = randi_range(1, 3)
	for i in range(attack_choices):
		var choices = randi_range(1, 4)
		match choices:
			1:
				attacks.append(actions.HEAL)
			2:
				attacks.append(actions.DAMAGE)
			3:
				attacks.append(actions.BUFF)
			4:
				attacks.append(actions.DEBUFF)
