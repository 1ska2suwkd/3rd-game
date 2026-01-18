extends Node

var dialogues: Array[DialogueData] = []
var text_box_scene = preload("res://UI/TextBox/Text_Box_UI.tscn")

var on_sequence_finished: Callable = Callable()

func _ready() -> void:
	pass
	
func start_dialogue(sequence: Array[DialogueData], callback: Callable = Callable()):
	dialogues = sequence.duplicate() # 데이터 복사
	on_sequence_finished = callback # 받아온 시그널 저장
	
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
	
	if on_sequence_finished.is_valid():
		on_sequence_finished.call()
		on_sequence_finished = Callable() # 실행 후 초기화
