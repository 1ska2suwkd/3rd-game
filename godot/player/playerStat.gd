#playerStat.gd
extends Node2D

var damage = 5
var speed = 400
var hp = 3
var attack_speed = 2.3
var attack_slow = 0.7

var gold = 0

signal stats_changed()  # 현재 gd의 stats_changed()라는 함수 시그널 정의


func set_damage(d):
	damage += d
	emit_signal("stats_changed") # 시그널 발생
func set_speed(d):
	speed += d
	emit_signal("stats_changed")
func set_attack_speed(a):
	attack_speed += a
	emit_signal("stats_changed")
func set_attack_slow(a):
	attack_slow += a
	emit_signal("stats_changed")
func set_gold(d):
	gold += d
	emit_signal("stats_changed")
