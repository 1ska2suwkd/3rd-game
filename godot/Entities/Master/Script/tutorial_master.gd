extends Node2D

@export var interaction_component: InteractionComponent

func _ready() -> void:
	interaction_component.press_interaction.connect(spawn_master_textbox)


func spawn_master_textbox():
	
	var master_textbox = preload("res://UI/TextBox/Master/Master_Text_Box.tscn").instantiate()
	master_textbox.is_skilltree = false
	master_textbox.queue_text("안녕!")
	master_textbox.queue_text("어렵지 않았지?")
	master_textbox.queue_text("수고많았다 이제 마을로 돌아가자")
	get_tree().current_scene.add_child(master_textbox)
	
