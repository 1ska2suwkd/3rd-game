extends Area2D
class_name AttackHitboxComponent

var stats: EnemyStat


func _on_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("player"):
		var target = area.owner
		target.apply_knockback(global_position, 1000.0, 0.5, stats.damage)
