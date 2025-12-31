extends CharacterBody2D

@export var HarpoonFishStats: EnemyStat
@export var player: CharacterBody2D
@export var movement_component: MoveComponent
@export var wander_component: WanderComponent


var is_attack = false

func _ready() -> void:
	movement_component.stats = HarpoonFishStats
	$Components/ContactDamageComponent.stats = HarpoonFishStats
	$Components/HealthComponent.stats = HarpoonFishStats


func _physics_process(_delta: float) -> void:
	if not is_attack:
		# 애니메이션
		if velocity.length() > 0.1:
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.play("idle")

func _on_attack_timeout() -> void:
	if not player == null:
		is_attack = true
		velocity = Vector2.ZERO
		if player.global_position.x < global_position.x:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
		$AnimatedSprite2D.play("attack")


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack":
		if $AnimatedSprite2D.frame == 4:
			attack()


func attack():
	var projectile = preload("res://projectiles/Harpoon.tscn").instantiate()
	projectile.global_position = global_position
	projectile.target = player
	#projectile.damage = stat.damage
	# 현재 씬에서 YSort 노드 찾기
	var ysort = get_tree().current_scene.get_node("Ysort")
	
	if ysort:
		ysort.add_child(projectile)
	else:
		push_warning("⚠️ YSort 노드를 찾을 수 없습니다. current_scene에 직접 추가합니다.")
		get_tree().current_scene.add_child(projectile)
	

func _on_animated_sprite_2d_animation_finished() -> void:
	is_attack = false
