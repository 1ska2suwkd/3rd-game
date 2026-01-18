extends Node2D
class_name TalkComponent

@export var conversation_sequence: Array[DialogueData]
@export var interaction_component: InteractionComponent

@export_category("Settings")
# 이 체크박스를 켜면 한 번만 대화하고, 끄면 무한 반복합니다.
@export var is_one_time: bool = false

var has_spoken: bool = false

signal conversation_finished

func _ready() -> void:
	interaction_component.press_interaction.connect(spawn_textbox)
	
func spawn_textbox():
	if is_one_time and has_spoken:
		return
	DialogueManager.start_dialogue(conversation_sequence, _on_dialogue_finished)
	
func _on_dialogue_finished():
	conversation_finished.emit()
	
	# 대화가 끝났으니 '대화 했음' 도장을 찍음
	has_spoken = true
