extends Node

var dialogues: Array[DialogueData] = []

signal dialogue_start()
signal dialogue_end()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue_start.connect(check_dialogue)
	dialogue_end.connect(check_dialogue)
	
func check_dialogue():
	if dialogues.is_empty():
		end_textbox()
	else:
		var text_box = preload("res://UI/TextBox/Text_Box_UI.tscn").instantiate()
		text_box.dialogue_data = dialogues.pop_front()
		get_tree().current_scene.add_child(text_box)

func end_textbox():
	EventBus.EndTextBox.emit()
