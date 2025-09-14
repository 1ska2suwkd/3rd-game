extends Stat

class_name PlayerStat

var attack_speed: float

func _init(speed: int, hp: int, damage: int, attack_speed: float):
	super._init(speed, hp, damage)
	self.attack_speed = attack_speed
