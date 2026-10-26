extends Label


var total_energy: float
# have to change it in the player global

func _ready() -> void:
	$"../flash".play("RESET")
	total_energy = PlayerStats.max_energy
	$"../energyBar".max_value = PlayerStats.max_energy
	$"../energyBar".value = PlayerStats.max_energy
	text = str(total_energy)
	Events.connect("reduce_energy_by", _reduced_energy)
	Events.connect("players_turn", _regenerate_energy)
	
func _regenerate_energy():
	$"../flash".stop()
	total_energy = PlayerStats.max_energy
	$"../energyBar".value = total_energy
	$"../ColorRect".visible = false
	text = str(total_energy)

func _reduced_energy(cost: float):
	if cost<= total_energy:
		total_energy -= cost
	$"../energyBar".value = total_energy
	if total_energy ==0:
		$"../flash".play("flash")
	Events.emit_signal("total_energy", total_energy)
	text = str(total_energy)
	
