#playerStat.gd
extends Stat
class_name PlayerStat

var attack_speed: float

func _init(p_speed: int = 400, p_hp: int = 3, p_damage: int = 1, p_attack_speed: float = 1.0):
	super._init(p_speed, p_hp, p_damage)
	self.attack_speed = p_attack_speed

func update_attack_speed(new_attack_speed: float):
	attack_speed = new_attack_speed
