#playerStat.gd
extends Node2D

var damage = 2
var speed = 400
var hp = 3
var attack_speed = 1.3
var attack_slow = 0.7

var gold = 11

var is_player_hit = false # 방에서 한 대라도 맞으면 스승 기술을 없애기 위한 변수
var attacking = false

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
