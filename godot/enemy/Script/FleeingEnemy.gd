extends "res://enemy/Script/BaseEnemy.gd"

@onready var nav_agent := $NavigationAgent2D
@export var flee_distance := 300.0

var is_fleeing := false
const PATH_UPDATE_INTERVAL := 0.15
const PLAYER_MOVE_THRESHOLD := 24.0 # 플레이어가 이만큼 이동하면 강제 갱신

var _path_update_timer := 0.0
var _last_player_pos := Vector2.INF

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if not is_attack:
		if is_fleeing and player:
			# 타이머 감소
			_path_update_timer -= delta

			# 플레이어가 충분히 이동했는지 체크
			var player_moved := _last_player_pos == Vector2.INF or player.global_position.distance_to(_last_player_pos) > PLAYER_MOVE_THRESHOLD

			# 타이머 만료 또는 플레이어가 많이 이동했을 때만 타겟 갱신
			if _path_update_timer <= 0.0 or player_moved:
				_path_update_timer = PATH_UPDATE_INTERVAL
				_last_player_pos = player.global_position

				var dir = (global_position - player.global_position)
				if dir.length() > 0.001:
					dir = dir.normalized()
					nav_agent.target_position = global_position + dir * flee_distance
				# dir가 거의 0이면 타겟 갱신 안 함

			# 다음 경로 지점 얻기 (가벼운 체크 추가)
			var next_pos = nav_agent.get_next_path_position()
			if (next_pos - global_position).length() > 0.01:
				var move_dir = (next_pos - global_position)
				# normalize 전에 길이 체크
				if move_dir.length() > 0.001:
					move_dir = move_dir.normalized()
					velocity = move_dir * stat.speed
				else:
					velocity = Vector2.ZERO
			else:
				velocity = Vector2.ZERO
		else:
			velocity = Vector2.ZERO

		if velocity.length() > 1.0:
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.play("idle")


func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		is_fleeing = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		is_fleeing = false
