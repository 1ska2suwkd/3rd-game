extends CharacterBody2D

@export var ShamanStats: EnemyStat
@export var player: CharacterBody2D
@onready var movement_component = $Components/MovementComponent
@onready var detection_component = $Components/DetectionComponent

var is_attack = false

const PATH_UPDATE_INTERVAL := 0.15
const PLAYER_MOVE_THRESHOLD := 24.0 # 플레이어가 이만큼 이동하면 강제 갱신

var _path_update_timer := 0.0
var _last_player_pos := Vector2.INF

func _ready() -> void:
	$Components/ContactDamageComponent.stats = ShamanStats
	$Components/HealthComponent.stats = ShamanStats
	movement_component.stats = ShamanStats
	
	randomize()
	start_random_timer()
	
@onready var nav_agent := $NavigationAgent2D
@export var flee_distance := 300.0

func _physics_process(delta: float) -> void:

	if not is_attack:
		if detection_component.player_in_area and player:
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
					movement_component.move(move_dir, delta)
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
	
func start_random_timer() -> void:
	$attack.wait_time = randf_range(1.0, 3.0)
	$attack.start()

func _on_attack_timeout() -> void:
	is_attack = true
	velocity = Vector2.ZERO
	if player.global_position.x < global_position.x:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
	$AnimatedSprite2D.play("attack")


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack":
		if $AnimatedSprite2D.frame == 5:
			attack()


func attack():
	var projectile = preload("res://projectiles/Shaman_Projectile.tscn").instantiate()
	projectile.target = player
	projectile.global_position = projectile.target.global_position
	projectile.damage = ShamanStats.damage
	# 현재 씬에서 YSort 노드 찾기
	var ysort = get_tree().current_scene.get_node("Ysort")

	if ysort:
		ysort.add_child(projectile)
	else:
		push_warning("⚠️ YSort 노드를 찾을 수 없습니다. current_scene에 직접 추가합니다.")
		get_tree().current_scene.add_child(projectile)
	

func _on_animated_sprite_2d_animation_finished() -> void:
	is_attack = false
	start_random_timer()
