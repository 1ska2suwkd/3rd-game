#playerStat.gd
extends Stat
class_name PlayerStat

var attack_speed: float

func _init(speed: int = 400, hp: int = 3, damage: int = 1, attack_speed: float = 1.0):
	super._init(speed, hp, damage)
	self.attack_speed = attack_speed

func update_attack_speed(new_attack_speed: float):
	attack_speed = new_attack_speed
