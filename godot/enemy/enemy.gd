extends CharacterBody2D

var stat: Stat
var playerstat : PlayerStat

var player_chase = false
var player = null

func _ready():
	stat = Stat.new(200, 10, 2) # speed, hp, damage
	
func _physics_process(_delta):
	var dir := Vector2.ZERO
	if player_chase and player:
		dir = (player.global_position - global_position).normalized()

	velocity = dir * stat.speed
	move_and_slide()  # ← 물리 이동 (충돌 적용)

	# 애니메이션 & 좌우 반전
	if velocity.length() > 1.0:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.play("idle")

func _on_area_2d_area_entered(area):
	if area.is_in_group("Player_attack"):
		$AnimatedSprite2D.modulate = Color(0.847, 0.0, 0.102)
	playerstat = PlayerStat.new()
	stat.take_damage(playerstat.damage)
	if stat.dead:
		queue_free()# Replace with function body.

func _on_area_2d_area_exited(area):
	if area.is_in_group("Player_attack"):
		$AnimatedSprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player = null
		player_chase = false
