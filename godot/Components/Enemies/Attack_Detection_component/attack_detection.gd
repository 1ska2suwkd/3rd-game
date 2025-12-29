extends Area2D
class_name AttackDetectionComponent


func _on_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("player"):
		EventBus.emit_signal("target_enter_range")
