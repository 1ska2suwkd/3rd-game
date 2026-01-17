extends Node2D

@export var dialogue_data: DialogueData
@export var interaction_component: InteractionComponent

var is_player_in_area: bool = false

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if is_player_in_area and event.Input.is_action_just_pressed("Interaction") and not global.is_stop:
		var textbox = preload("res://UI/TextBox/Text_Box_UI.tscn").instantiate()
		textbox.dialogue_data = preload("res://Resources/DialogueData/Pex.tres")
		
		get_tree().current_scene.add_child(textbox)
	
func _on_talk_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_in_area = true
		EventBus.emit_signal("show_hint_ui")


func _on_talk_area_body_exited(body: Node2D) -> void:
	if Input.is_action_just_pressed("Interaction"): return
	if body.is_in_group("player"):
		EventBus.emit_signal("hide_hint_ui")
		is_player_in_area = false
