extends CharacterBody2D
@export var SkullStat: EnemyStat
@export var player: CharacterBody2D

@export var movement_component: MoveComponent
@export var detection_component: DetectionComponent
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
var is_attack = false

func _ready() -> void:

	$Components/ContactDamage.stats = SkullStat
	$Components/HealthComponent.stats = SkullStat
	$Components/MovementComponent.stats = SkullStat
	$Components/AttackHitboxComponent.stats = SkullStat

func _physics_process(_delta: float) -> void:
	var direction_to_player = global_position.direction_to(player.global_position)
	
	if not is_attack:
		# --- 방향 계산 ---
		var dir = Vector2.ZERO
		# 플레이어를 쫓는 상황이면 네비게이션으로 방향을 구함
		if detection_component.player_chase and detection_component.player:
			# get_next_path_position()은 전역 좌표이므로 to_local로 로컬 방향으로 변환
			dir = to_local(nav_agent.get_next_path_position()).normalized()
		
		# --- [핵심 변경] 컴포넌트에게 명령 ---
		if dir != Vector2.ZERO:
			# "이 방향으로 가라" (가속 적용)
			movement_component.move(dir, _delta)
		else:
			# "방향이 없으면 멈춰라" (마찰 적용)
			movement_component.stop(_delta)
		
		# --- 애니메이션 처리 (기존 로직 유지) ---
		# 컴포넌트가 move_and_slide를 했으니, 적의 실제 velocity가 변해있음. 그걸 읽어오면 됨.
		if velocity.length() > 1.0 :
			$AnimatedSprite2D.play("walk")
			
			# 좌우 반전 로직
			if abs(velocity.x) > 1.0: 
				if direction_to_player.x < 0:
					$AnimatedSprite2D.flip_h = true
					$Components/AttackHitboxComponent.scale.x = -1
				else:
					$AnimatedSprite2D.flip_h = false
					$Components/AttackHitboxComponent.scale.x = 1
					
		else:
			$AnimatedSprite2D.play("idle")
			
	else:
		# 공격 중일 때 정지
		# velocity = Vector2.ZERO 대신 stop을 써서 부드럽게 멈춤 (원하면 강제 0 할당도 가능)
		movement_component.stop(_delta)


func _on_attack_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_attack = true
		$AnimatedSprite2D.play("attack")


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack":
		if $AnimatedSprite2D.frame == 2:
			$Components/AttackHitboxComponent/attack_hitbox.disabled = false


func _on_animated_sprite_2d_animation_finished() -> void:
	is_attack = false
	$Components/AttackHitboxComponent/attack_hitbox.disabled = true
	



func makepath() -> void: #플레이어를 찾기위한 경로탐색 함수?
	nav_agent.target_position = player.global_position


func _on_pathfinding_timeout() -> void:
	makepath()
