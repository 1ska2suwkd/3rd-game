extends Area2D
class_name InteractionComponent

var is_player_in_area: bool = false
signal press_interaction()
signal on_body_enter()
signal on_body_exit()

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if is_player_in_area and event.is_action_pressed("Interaction") and not global.is_stop:
		press_interaction.emit()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_in_area = true
		on_body_enter.emit()

func _on_body_exited(body: Node2D) -> void:
	if Input.is_action_just_pressed("Interaction"): return
	if body.is_in_group("player"):
		is_player_in_area = false
		on_body_exit.emit()
