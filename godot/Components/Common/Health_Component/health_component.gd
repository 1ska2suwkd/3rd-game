extends Node2D
class_name HealthComponent

@export var death_component: DeathComponent

signal change_hp(hp)

var hp = 0
var stats: EnemyStat:
	set(new_stats):
		stats = new_stats
		if stats:
			hp = stats.max_hp


func damage(p_damage):
	hp -= p_damage
	change_hp.emit(hp)
	if hp <= 0:
		death_component.die()
