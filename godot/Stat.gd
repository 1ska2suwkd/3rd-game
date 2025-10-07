# Stat.gd
extends Node

class_name Stat

var speed: int
var hp: int
var damage: int

func _init(p_speed:int, p_hp:int, p_damage:int):
	self.speed = p_speed
	self.hp = p_hp
	self.damage = p_damage


func update_speed(new_speed: int):
	self.speed = new_speed

func update_damage(new_damage: int):
	self.damage = new_damage
