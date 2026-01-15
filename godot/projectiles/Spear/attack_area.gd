extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("enemy"):
		area.take_damage(PlayerStat.TotalDamage, owner.global_position)
