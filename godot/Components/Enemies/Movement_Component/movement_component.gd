extends Node2D
class_name MoveComponent

@export var body: CharacterBody2D 
var stats: EnemyStat

# 움직임의 퀄리티를 결정하는 변수들 (직접 조절 가능)
@export var acceleration: float = 800.0 # 출발할 때 얼마나 빨리 최고 속도에 도달하는가
@export var friction: float = 1000.0    # 멈출 때 얼마나 미끄러지며 멈추는가
var CanMove: bool = false

# [핵심] 방향만 주면 알아서 움직여주는 함수
func move(direction: Vector2, _delta: float) -> void:
	pass
	if CanMove:
		# 스탯 리소스가 있으면 거기 있는 속도를 쓰고, 없으면 기본값 100 사용
		var current_speed = stats.speed
		
		# 가고 싶은 방향으로 속도를 서서히 올림 (가속)
		body.velocity = body.velocity.move_toward(direction * current_speed, acceleration * _delta)
		
		body.move_and_slide()
	else:
		stop(_delta)
		return

func stop(_delta: float) -> void:
	pass
	# 속도를 0으로 서서히 줄임 (마찰)
	body.velocity = body.velocity.move_toward(Vector2.ZERO, friction * _delta)
	
	body.move_and_slide()


func _on_start_move_timeout() -> void:
	CanMove = true
