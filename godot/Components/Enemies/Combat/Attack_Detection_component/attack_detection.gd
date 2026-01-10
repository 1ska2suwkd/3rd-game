extends Area2D
class_name AttackDetectionComponent

signal target_enter_range()

func _on_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("player"):
		target_enter_range.emit()
