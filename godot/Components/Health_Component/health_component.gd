extends Node2D
class_name HealthComponent

@export var stats: Resource

var hp: int = stats.max_hp
@onready var AnimationSprite = $"../../AnimatedSprite2D"

func damage(p_damage):
	hp -= p_damage
	if hp <= 0:
		pass
		#시그널 넣어서 DeathComponent 랑 연결 필요
