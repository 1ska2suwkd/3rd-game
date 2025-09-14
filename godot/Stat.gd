# Stat.gd
extends Node

class_name Stat

var speed: int
var hp: int
var damage: int

var speed_updated: bool = false
var damage_updated: bool = false

func _init(speed:int, hp:int, damage:int):
	self.speed = speed
	self.hp = hp
	self.damage = damage
	
func take_damage(damage:int):
	hp -= damage
	if hp <= 0:
		return true # 사망하면 true 반환
	else:
		return false

func update_speed(new_speed: int):
	speed = new_speed

func update_damage(new_damage: int):
	damage = new_damage
