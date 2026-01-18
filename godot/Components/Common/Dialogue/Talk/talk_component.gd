extends Node2D
class_name TalkComponent

@export var conversation_sequence: Array[DialogueData]
@export var interaction_component: InteractionComponent

@export_category("Settings")
# 이 체크박스를 켜면 한 번만 대화하고, 끄면 무한 반복합니다.
@export var is_one_time: bool = false

signal conversation_finished

func _ready() -> void:
	interaction_component.press_interaction.connect(spawn_textbox)
	
func spawn_textbox():
	DialogueManager.start_dialogue(conversation_sequence, _on_dialogue_finished)
	
func _on_dialogue_finished():
	conversation_finished.emit()
	
	if is_one_time:
		# interaction_component 연결해제 (쉐이더, 힌트 UI 삭제)
		interaction_component.on_body_exit.emit()
		interaction_component.queue_free()
