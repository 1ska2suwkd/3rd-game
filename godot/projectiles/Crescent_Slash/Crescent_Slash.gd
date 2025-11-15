extends Area2D

@export var speed: float = 1300
var damage: int = 0
var direction: Vector2 = Vector2.ZERO
var start_position: Vector2

func _ready() -> void:
	start_position = global_position

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
	if start_position.distance_to(global_position) >= (PlayerStat.attack_range * 100): # attack_range가 플레이어한테 보일땐 한자리지만 실제로 거리계산을 할땐 값이 더 커야함
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		#관통의 화살을 얻으면 투사체가 적에 닿아도 사라지지 않음
		if PlayerStat.player_inv.items[3] == null:
			queue_free()
	elif body.is_in_group("Wall"):
		queue_free()
	
	
