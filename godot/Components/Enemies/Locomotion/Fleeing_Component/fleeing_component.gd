extends Node2D

@export var movement_component: MoveComponent
@export var detection_component: DetectionComponent
@export var flee_distance := 300.0
@onready var enemy: CharacterBody2D = owner
@onready var nav_agent := $NavigationAgent2D

const PATH_UPDATE_INTERVAL := 0.15
const PLAYER_MOVE_THRESHOLD := 24.0 # 플레이어가 이만큼 이동하면 강제 갱신

var _path_update_timer := 0.0
var _last_player_pos := Vector2.INF


func _physics_process(delta: float) -> void:

	if not enemy.is_attack:
		if detection_component.player_in_area:
			# 타이머 감소
			_path_update_timer -= delta

			# 플레이어가 충분히 이동했는지 체크
			var player_moved := _last_player_pos == Vector2.INF or detection_component.target.global_position.distance_to(_last_player_pos) > PLAYER_MOVE_THRESHOLD

			# 타이머 만료 또는 플레이어가 많이 이동했을 때만 타겟 갱신
			if _path_update_timer <= 0.0 or player_moved:
				_path_update_timer = PATH_UPDATE_INTERVAL
				_last_player_pos = detection_component.target.global_position

				var dir = (global_position - detection_component.target.global_position)
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
					movement_component.move(move_dir, delta)
				else:
					movement_component.stop(delta)
			else:
				movement_component.stop(delta)
		else:
			movement_component.stop(delta)
