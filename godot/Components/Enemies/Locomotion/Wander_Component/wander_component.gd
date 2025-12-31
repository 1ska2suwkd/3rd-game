extends Node2D
class_name WanderComponent

@export var movement_component :MoveComponent
@onready var enemy: CharacterBody2D = owner

var wander_dir := Vector2.ZERO
var wander_timer := 0.0

func _physics_process(_delta: float) -> void:
	if not enemy.is_attack:
		wander_timer -= _delta
		if wander_timer <= 0.0:
			# 새 방향 선택 (랜덤)
			var angle = randf_range(0, PI*2)
			wander_dir = Vector2(cos(angle), sin(angle)).normalized()
			wander_timer = randf_range(1.0, 1.0)  # 1~3초마다 방향 바꿈
		
		movement_component.move(wander_dir, _delta)
