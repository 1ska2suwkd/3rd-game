#playerStat.gd
extends Node2D

@onready var player_inv: Inventory = preload("res://Resources/Inventory/Player_Inventory.tres")

var damage = 10
var speed = 400
var hp = 3
var attack_speed = 1.3
var attack_slow = 0.7
var attack_range = 5
var gold = 11

var is_player_hit = false # 방에서 한 대라도 맞으면 스승 기술을 없애기 위한 변수
var attacking = false


func set_damage(d):
	damage += d
	EventBus.emit_signal("stats_changed") # 시그널 발생
func set_speed(d):
	speed += d
	EventBus.emit_signal("stats_changed")
func set_attack_speed(a):
	attack_speed += a
	EventBus.emit_signal("stats_changed")
func set_attack_slow(a):
	attack_slow += a
	EventBus.emit_signal("stats_changed")
func set_attack_range(d):
	attack_range += d
	EventBus.emit_signal("stats_changed")
func set_gold(d):
	gold += d
	EventBus.emit_signal("stats_changed")
