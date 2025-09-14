#playerStat.gd
extends Stat

class_name PlayerStat

var attack_speed: float
var attack_speed_updated: bool = false

func _init(speed: int, hp: int, damage: int, attack_speed: float):
	super._init(speed, hp, damage)
	self.attack_speed = attack_speed

func update_attack_speed(new_attack_speed: float):
	attack_speed = new_attack_speed
	if $AnimatedSprite2D.animation != "idle":
		$AnimatedSprite2D.speed_scale = attack_speed
