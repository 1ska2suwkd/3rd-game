extends Node

var dialogues: Array[DialogueData] = []
var text_box_scene = preload("res://UI/TextBox/Text_Box_UI.tscn")

#signal dialogue_start()
#signal dialogue_end()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#dialogue_start.connect(check_dialogue)
	#dialogue_end.connect(check_dialogue)
	pass
	
func start_dialogue(sequence: Array[DialogueData]):
	dialogues = sequence.duplicate() # 데이터 복사
	check_dialogue() # 첫 대화 시작
	
func check_dialogue():
	if dialogues.is_empty():
		end_textbox()
	else:
		var text_box = text_box_scene.instantiate()
		get_tree().current_scene.add_child(text_box)
		var next_data = dialogues.pop_front()
		text_box.start(next_data)
		
		text_box.finished_current_dialogue.connect(check_dialogue)

func end_textbox():
	global.is_stop = false
	EventBus.EndTextBox.emit()
