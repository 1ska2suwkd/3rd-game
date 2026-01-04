#playerStat.gd
extends Node2D

@onready var player_inv: Inventory = preload("res://Resources/Inventory/Player_Inventory.tres")

var hp = 3
var PlayerAttackSlow = 0.7
var gold = 10

var PlayerDamage = 10
var ItemDamage = 0
var TotalDamage = PlayerDamage + ItemDamage

var PlayerSpeed = 400
var ItemSpeed = 0
var TotalSpeed = PlayerSpeed + ItemSpeed

var PlayerAttackSpeed = 1.3
var ItemAttackSpeed = 0
var TotalAttackSpeed = PlayerAttackSpeed + ItemAttackSpeed

var PlayerAttackRange = 5
var ItemAttackRange = 0
var TotalAttackRange = PlayerAttackRange + ItemAttackRange


var is_player_hit = false # 방에서 한 대라도 맞으면 스승 기술을 없애기 위한 변수
var attacking = false

func InitPlayerStat():
	TotalDamage = PlayerDamage
	ItemDamage = 0
	
	TotalSpeed = PlayerSpeed
	ItemSpeed = 0
	
	TotalAttackSpeed = PlayerAttackSpeed
	ItemAttackSpeed = 0
	
	TotalAttackRange = PlayerAttackRange
	ItemAttackRange = 0
	
func set_damage(d):
	ItemDamage += d
	TotalDamage = PlayerDamage + ItemDamage
	EventBus.emit_signal("stats_changed") # 시그널 발생
func set_speed(d):
	ItemSpeed += d
	TotalSpeed = PlayerSpeed + ItemSpeed
	EventBus.emit_signal("stats_changed")
func set_attack_speed(a):
	ItemAttackSpeed += a
	TotalAttackSpeed = PlayerAttackSpeed + ItemAttackSpeed
	EventBus.emit_signal("stats_changed")
func set_attack_range(d):
	ItemAttackRange += d
	TotalAttackRange = PlayerAttackRange + ItemAttackRange
	EventBus.emit_signal("stats_changed")
func set_gold(d):
	gold += d
	EventBus.emit_signal("stats_changed")

# 슬로우는 아이템으로 한번에 제거할 예정이라 우선 주석처리
#func set_attack_slow(a):
	#ItemDamage += a
	#TotalDamage = PlayerDamage + ItemDamage
	#EventBus.emit_signal("stats_changed")
