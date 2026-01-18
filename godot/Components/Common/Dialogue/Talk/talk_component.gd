extends Node2D
class_name TalkComponent

@export var conversation_sequence: Array[DialogueData]
@export var interaction_component: InteractionComponent

signal conversation_finished

func _ready() -> void:
	interaction_component.press_interaction.connect(spawn_textbox)
	
func spawn_textbox():
	#var textbox = preload("res://UI/TextBox/Text_Box_UI.tscn").instantiate()
	
	DialogueManager.start_dialogue(conversation_sequence, func(): conversation_finished.emit())
	#get_tree().current_scene.add_child(textbox)
