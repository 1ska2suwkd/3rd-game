extends Area2D
class_name ContactDamageComponent

var stats: EnemyStat

func _on_contact_damage_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("player"):
		var target = area.owner
		target.apply_knockback(global_position, 1000.0, 0.1, stats.damage)
