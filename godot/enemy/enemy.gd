extends CharacterBody2D

var stat: Stat
var playerstat : PlayerStat

var player_chase = false
var player = null

func _ready():
	stat = Stat.new(100,6, 2)
	
func _physics_process(_delta):
	if player_chase:
		position += (player.position - position) / stat.speed
		$AnimatedSprite2D.play("walk")
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
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
