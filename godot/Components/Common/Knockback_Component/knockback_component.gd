extends Node2D
class_name KnockbackComponent

@export var body: CharacterBody2D
var knockback_vel: Vector2 = Vector2.ZERO
var knockback_time := 0.0 


func _physics_process(_delta: float) -> void:
	if knockback_time > 0.0:
		print(knockback_time)
		# 넉백 중: 입력 무시하고 넉백 속도 적용 + 감속
		body.velocity = knockback_vel
		knockback_vel = knockback_vel.move_toward(Vector2.ZERO, 3000.0 * _delta)  # 감속량 조절
		knockback_time -= _delta
		
		

func apply_knockback(from: Vector2, strength: float = 400, duration: float = 0.15) -> void:
	#if dead: return
	
	var dir := (body.global_position - from).normalized()
	knockback_vel = dir * strength
	knockback_time = duration
