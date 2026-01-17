extends Node2D
class_name DeathComponent

var is_die = false
signal _die()

func die():
	if is_die: return
	is_die = true
	
	EventBus.enemy_die.emit()
	_die.emit()
	
