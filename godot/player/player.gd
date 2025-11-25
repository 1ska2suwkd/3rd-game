# player.gd
extends CharacterBody2D

var dead = false

# 공격하면서 이동 시 이동속도 감소
var combo = "1"
var attackDir = ""
var hit_active_token := 0


var knockback_vel: Vector2 = Vector2.ZERO
var knockback_time := 0.0 

var hearts_list : Array[TextureRect]

@onready var up_hit: CollisionShape2D = $AttackCollision/UpAttack
@onready var down_hit: CollisionShape2D = $AttackCollision/DownAttack
@onready var right_hit: CollisionShape2D = $AttackCollision/RightAttack
@onready var left_hit: CollisionShape2D = $AttackCollision/LeftAttack

#@export var player_inv = preload("res://Resources/Inventory/Player_Inventory.tres")

func _ready():
	PlayerStat.attacking = false
	var hearts_parent = $UI/Hearts
	for child in hearts_parent.get_children():
		hearts_list.append(child)
	init_heart_display()

	if MasterSkill.Crescent_Slash:
		PlayerStat.player_inv.items[0] = MasterSkill.Crescent_Slash_item
		EventBus.emit_signal("add_item")


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
		
		
func _process(_delta):
	if $AnimatedSprite2D.animation == "idle" or $AnimatedSprite2D.animation == "walk":
		$AnimatedSprite2D.speed_scale = 1.0
	else:
		$AnimatedSprite2D.speed_scale = PlayerStat.TotalAttackSpeed
	
	
func _physics_process(_delta):
	if dead: 
		return
	elif global.is_stop:
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
			
func spawn_crescent_slash(path, direction):
	if MasterSkill.Crescent_Slash and not PlayerStat.is_player_hit:
		var scene = load(path)
		var projectile = scene.instantiate()
		projectile.global_position = global_position
		projectile.damage = PlayerStat.TotalDamage
		projectile.direction = direction
		get_tree().current_scene.add_child(projectile)
			
func _on_animated_sprite_2d_frame_changed():
	var anim = $AnimatedSprite2D.animation
	var frame = $AnimatedSprite2D.frame
	
	if anim == "up_attack1" or anim == "up_attack2":
		if frame == 3:  # 타격 시작 프레임
			$AttackCollision/UpAttack.disabled = false
			spawn_crescent_slash("res://projectiles/Crescent_Slash/up_Crescent_Slash.tscn", Vector2(0,-1))
		elif frame == 5:  # 타격 종료 프레임
			$AttackCollision/UpAttack.disabled = true
	elif anim == "down_attack1" or anim == "down_attack2":
		if frame == 3:  # 타격 시작 프레임
			$AttackCollision/DownAttack.disabled = false
			spawn_crescent_slash("res://projectiles/Crescent_Slash/down_Crescent_Slash.tscn", Vector2(0,1))
		elif frame == 5:  # 타격 종료 프레임
			$AttackCollision/DownAttack.disabled = true
	elif anim == "left_attack1" or anim == "left_attack2":
		if frame == 3:  # 타격 시작 프레임
			$AttackCollision/LeftAttack.disabled = false
			spawn_crescent_slash("res://projectiles/Crescent_Slash/left_Crescent_Slash.tscn", Vector2(-1,0))
		elif frame == 5:  # 타격 종료 프레임
			$AttackCollision/LeftAttack.disabled = true
	elif anim == "right_attack1" or anim == "right_attack2":
		if frame == 3:  # 타격 시작 프레임
			$AttackCollision/RightAttack.disabled = false
			spawn_crescent_slash("res://projectiles/Crescent_Slash/right_Crescent_Slash.tscn", Vector2(1,0))
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
	global.change_scene("res://StartScene/StartScene.tscn")
	global.init_game()
