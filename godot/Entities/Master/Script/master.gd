extends Node2D

@export var interaction_component: InteractionComponent

func _ready() -> void:
	interaction_component.press_interaction.connect(spawn_master_textbox)

	
func spawn_master_textbox():
	var master_textbox = preload("res://UI/TextBox/Master/Master_Text_Box.tscn").instantiate()
	master_textbox.is_skilltree = true
	master_textbox.queue_text("강력한 기술을 알려줄게!")
	get_tree().current_scene.add_child(master_textbox)
