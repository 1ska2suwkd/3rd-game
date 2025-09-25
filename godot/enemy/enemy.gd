extends Area2D

var stat: Stat
var playerstat : PlayerStat

var player_chase = false
var player = null

func _ready():
	stat = Stat.new(200, 6, 2)
	
func _physics_process(delta):
	if player_chase:
		position += (player.position - position) / stat.speed

func _on_area_entered(area):
	if area.is_in_group("Player_attack"):
		$AnimatedSprite2D.modulate = Color(0.847, 0.0, 0.102)
	playerstat = PlayerStat.new()
	stat.take_damage(playerstat.damage)
	if stat.dead:
		queue_free()

func _on_area_exited(area):
	if area.is_in_group("Player_attack"):
		$AnimatedSprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
