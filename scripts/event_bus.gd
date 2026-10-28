extends Node

# all the event in the game i think
@warning_ignore_start("unused_signal")
signal card_selected(id)
signal in_attack_area
signal out_attack_area

signal update_id

## if which is null then it damages all
signal damaged_enemy(damage:int, anim:IngameStats.DamageAnim, which:Enemy)
signal damaged_player(damage:int, anim:IngameStats.DamageAnim)

signal reduce_energy_by(cost)
signal total_energy(total)

signal give_side_effects_to_player(effect:EffectData, value:int)
## if which is null then it effects all
signal give_side_effects_to_enemies(effect:EffectData, value:int, which:Enemy)

signal dialogue

signal players_turn
signal enemies_turn(attacking_enemy)

signal id_chosen(id, damage)
signal id_effect_chosen(id, effect)

signal update_display(sentence)

signal show_status_text(text)
signal hide_status_text
@warning_ignore_restore("unused_signal")

