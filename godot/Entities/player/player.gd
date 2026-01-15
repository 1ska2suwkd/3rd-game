# player.gd
extends CharacterBody2D

@export var Crescent_Slash: bool = false
@export var speer: bool = false

var dead = false

# 공격하면서 이동 시 이동속도 감소
var combo = "1"
var attackDir = ""
var hit_active_token := 0


var knockback_vel: Vector2 = Vector2.ZERO
var knockback_time := 0.0 

var hearts_list : Array[TextureRect]


const CRESCENT_SLASH = preload("res://projectiles/Crescent_Slash/XCrescent_Slash.tscn")
const SPEER = preload("res://projectiles/Speer/speer.tscn")

@onready var INVENTORY_UI = $UI/InventoryUi
@onready var up_hit: CollisionShape2D = $AttackCollision/UpAttack
@onready var down_hit: CollisionShape2D = $AttackCollision/DownAttack
@onready var right_hit: CollisionShape2D = $AttackCollision/RightAttack
@onready var left_hit: CollisionShape2D = $AttackCollision/LeftAttack
@onready var attack_range_collision: CollisionShape2D = $AttackRange/AttackRangeCollision


#@export var player_inv = preload("res://Resources/Inventory/Player_Inventory.tres")

func _ready():
	PlayerStat.attacking = false
	var hearts_parent = $UI/PlayerUI/Hearts
	for child in hearts_parent.get_children():
		hearts_list.append(child)
	init_heart_display()

	if Crescent_Slash:
		PlayerStat.player_inv.items[0] = MasterSkill.Crescent_Slash_item
		MasterSkill.crescnet_count += 1
		EventBus.emit_signal("update_inv_ui")
	if speer:
		PlayerStat.player_inv.items[1] = MasterSkill.speer_item
		MasterSkill.crescnet_count += 1
		EventBus.emit_signal("update_inv_ui")
	
	attack_range_collision.scale *= PlayerStat.TotalAttackRange

	#MasterSkill.Crescent_Slash = true # 임시

func update_heart_display():
	var target_hp = max(PlayerStat.hp, 0) # 인덱스 언더플로우 방지
	while hearts_list.size() > target_hp:
		var heart = hearts_list[-1].get_node("heart")
		if heart.animation != "heart_loss":
			heart.play("heart_loss")
		hearts_list.pop_back()
	
		
func init_heart_display():
	var target_hp = max(PlayerStat.hp, 0) # 인덱스 언더플로우 방지
	
	while hearts_list.size() > target_hp:
		var heart = hearts_list[-1].get_node("heart")
		heart.play("lossed_heart")
			
		hearts_list.pop_back()

func take_damage(p_damage:int):
	PlayerStat.hp -= p_damage
	if not PlayerStat.is_player_hit:
		PlayerStat.is_player_hit = true
	if PlayerStat.hp <= 0:
		is_dead()
		
const MAX_ANGLE = 45.0
const MAX_VELOCITY = 2000.0 
const SMOOTH_SPEED = 10.0 # 숫자가 클수록 반응이 빠름
var current_speer_angle = 0.0
		
func _process(_delta):
	if $AnimatedSprite2D.animation == "idle" or $AnimatedSprite2D.animation == "walk":
		$AnimatedSprite2D.speed_scale = 1.0
	else:
		$AnimatedSprite2D.speed_scale = PlayerStat.TotalAttackSpeed
	
	
	# 1. 마우스의 현재 속도(Vector2)를 가져옵니다.
	var mouse_velocity = Input.get_last_mouse_velocity()
	
	# 2. X축 속도를 이용해 목표 각도 계산
	# 왼쪽(-)으로 가면 양수(+) 각도가 나와야 하므로 - 부호 붙임
	var target_angle = -(mouse_velocity.x / MAX_VELOCITY) * MAX_ANGLE
	
	# 3. 각도 제한
	target_angle = clamp(target_angle, -MAX_ANGLE, MAX_ANGLE)
	
	# 4. 부드러운 움직임 (Lerp)
	# 마우스가 멈추면 velocity가 자동으로 0이 되므로, 알아서 0도로 돌아옵니다.
	# 하지만 너무 확확 바뀌지 않게 lerp로 부드럽게 따라가게 해줍니다.
	current_speer_angle = lerp(current_speer_angle, target_angle, _delta * SMOOTH_SPEED)
	
func _physics_process(_delta):
	if dead: 
		return
	if global.is_stop:
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("idle")
		return
	
	if knockback_time > 0.0:
		# 넉백 중: 입력 무시하고 넉백 속도 적용 + 감속
		velocity = knockback_vel
		knockback_vel = knockback_vel.move_toward(Vector2.ZERO, 3000.0 * _delta)  # 감속량 조절
		knockback_time -= _delta
	else:	
		var dir := Vector2.ZERO
		if Input.is_action_pressed("move_up"):
			dir.y -= 1
		if Input.is_action_pressed("move_down"):
			dir.y += 1
		if Input.is_action_pressed("move_left"):
			dir.x -= 1
		if Input.is_action_pressed("move_right"):
			dir.x += 1
		# 방향 벡터 정규화 후 속도 적용
		if dir != Vector2.ZERO:
			if not PlayerStat.attacking:
				velocity = dir.normalized() * PlayerStat.TotalSpeed
				$AnimatedSprite2D.play("walk")
				if velocity.x < 0:
					$AnimatedSprite2D.flip_h = true
				elif velocity.x > 0:
					$AnimatedSprite2D.flip_h = false
			else:
				velocity = dir.normalized() * PlayerStat.TotalSpeed * PlayerStat.PlayerAttackSlow
				 
		else:
			velocity = Vector2.ZERO
			if not PlayerStat.attacking:
				$AnimatedSprite2D.play("idle")
			
		if Input.is_action_pressed("attack") and not PlayerStat.attacking:
			_do_attack()
		# 충돌 계산 포함된 이동
	move_and_slide()
	
func _do_attack():
	PlayerStat.attacking = true
	var mouse_pos = get_global_mouse_position()
	var to_mouse = mouse_pos - global_position
	
	if abs(to_mouse.x) > abs(to_mouse.y):
		attackDir = "right" if to_mouse.x > 0 else "left"
	else:
		attackDir = "down" if to_mouse.y > 0 else "up"
	
	if attackDir == "left":
		$AnimatedSprite2D.flip_h = true
	elif attackDir == "right":
		$AnimatedSprite2D.flip_h = false
	
	$AnimatedSprite2D.play(attackDir + "_attack" + combo)
	

func _on_animated_sprite_2d_animation_finished() -> void:
		PlayerStat.attacking = false
		if combo == "1":
			combo = "2"
		else:
			combo = "1"
			
func spawn_crescent_slash(direction):
	if PlayerStat.player_inv.items[0] == MasterSkill.Crescent_Slash_item and not PlayerStat.is_player_hit:
			# 1. 기준 위치 잡기 (플레이어의 중심 혹은 무기 위치)
		var center_pos = global_position # 혹은 $AimPivot/SpawnPoint.global_position

		# 2. 투사체 사이의 간격 설정
		var spacing = 20.0 # 투사체끼리 40픽셀 떨어짐

		# 3. 진행 방향의 '수직 벡터(옆 방향)' 구하기 (핵심!)
		# 오른쪽으로 쏠 땐 (0, 1)이 되어 위아래로 벌어짐
		# 위로 쏠 땐 (1, 0)이 되어 좌우로 벌어짐
		var side_vector = Vector2(-direction.y, direction.x)

		# 4. 정렬 시작점 계산 (짝수 개수일 때도 중앙이 맞도록)
		# 예: 2개일 때 -> -0.5, +0.5 위치
		# 예: 3개일 때 -> -1, 0, +1 위치
		var start_offset = -(spacing * (MasterSkill.crescnet_count - 1)) / 2.0
		$AimPivot.rotation = direction.angle()
		for i in range(MasterSkill.crescnet_count):
			var projectile = CRESCENT_SLASH.instantiate()
			var offset = side_vector * (start_offset + (i * spacing))
			projectile.global_position = center_pos + offset
			projectile.global_rotation = $AimPivot.rotation
			projectile.damage = PlayerStat.TotalDamage
			projectile.direction = direction
			var ysort = get_tree().current_scene.get_node("Ysort")
			if ysort:
				ysort.add_child(projectile)
			else:
				push_warning("⚠️ YSort 노드를 찾을 수 없습니다. current_scene에 직접 추가합니다.")
				get_tree().current_scene.add_child(projectile)


func spawn_speer():
	if PlayerStat.player_inv.items[1] == MasterSkill.speer_item:
		for i in range(MasterSkill.speer_count):
			var ysort = get_tree().current_scene.get_node("Ysort")
			var mouse_pos = get_global_mouse_position()
			
			var speer_instance = SPEER.instantiate()
			speer_instance.rotation_degrees = current_speer_angle
			speer_instance.global_position = mouse_pos
			
			ysort.add_child(speer_instance)
			
	

			
func _on_animated_sprite_2d_frame_changed():
	var anim = $AnimatedSprite2D.animation
	var frame = $AnimatedSprite2D.frame
	
	if anim == "up_attack1" or anim == "up_attack2":
		if frame == 3:  # 타격 시작 프레임
			$AttackCollision/UpAttack.disabled = false
			spawn_crescent_slash(Vector2(0,-1))
			spawn_speer()
		elif frame == 5:  # 타격 종료 프레임
			$AttackCollision/UpAttack.disabled = true
	elif anim == "down_attack1" or anim == "down_attack2":
		if frame == 3:  # 타격 시작 프레임
			$AttackCollision/DownAttack.disabled = false
			spawn_crescent_slash(Vector2(0,1))
			spawn_speer()
		elif frame == 5:  # 타격 종료 프레임
			$AttackCollision/DownAttack.disabled = true
	elif anim == "left_attack1" or anim == "left_attack2":
		if frame == 3:  # 타격 시작 프레임
			$AttackCollision/LeftAttack.disabled = false
			spawn_crescent_slash(Vector2(-1,0))
			spawn_speer()
		elif frame == 5:  # 타격 종료 프레임
			$AttackCollision/LeftAttack.disabled = true
	elif anim == "right_attack1" or anim == "right_attack2":
		if frame == 3:  # 타격 시작 프레임
			$AttackCollision/RightAttack.disabled = false
			spawn_crescent_slash(Vector2(1,0))
			spawn_speer()
		elif frame == 5:  # 타격 종료 프레임
			$AttackCollision/RightAttack.disabled = true

func apply_knockback(from: Vector2, strength: float = 500.0, duration: float = 0.15, p_damage: int = 1) -> void:
	if dead: return
	
	var dir := (global_position - from).normalized()
	knockback_vel = dir * strength
	knockback_time = duration
	$AnimatedSprite2D.modulate = Color(0.847, 0.0, 0.102)
	$HitFlashTimer.start()
	take_damage(p_damage)
	update_heart_display()

func _on_hit_flash_timer_timeout() -> void:
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	
func is_dead():
	dead = true
	$AnimatedSprite2D.play("dead")
	await $AnimatedSprite2D.animation_finished
	global.transition_scene = true
	global.change_scene("res://Scene/Village/Village.tscn")
	global.init_game()


func _on_attack_collision_area_entered(area: Area2D) -> void:
	if area.has_method("destroy"):
		area.take_damage(PlayerStat.TotalDamage)
	elif area.owner.is_in_group("enemy"):
		area.take_damage(PlayerStat.TotalDamage, global_position)


func _on_pickup_area_area_entered(area: Area2D) -> void:
	if area.has_method("use_item"):
		area.use_item()
		EventBus.emit_signal("update_inv_ui")
