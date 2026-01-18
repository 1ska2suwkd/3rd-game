extends CanvasLayer

const CHAR_READ_RATE = 0.1

var tween

var dialogue_data: DialogueData
signal finished_current_dialogue

@onready var textbox_container = $TextboxContainer
@onready var background = $ColorRect
@onready var character_texture: TextureRect = $character_texture
@onready var charater_name_container: MarginContainer = $CharaterNameContainer
@onready var charater_name_label: RichTextLabel = $CharaterNameContainer/charater_name_label
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var text = $TextboxContainer/MarginContainer/HBoxContainer/Text

enum State{
	READY,
	READING,
	FINISHED
}

var text_queue = []
var current_state = State.READY

func _ready() -> void:
	hide_textbox()

func start(data: DialogueData):
	dialogue_data = data
	
	character_texture.texture = dialogue_data.character_texture
	charater_name_label.text = dialogue_data.character_name
	
	text_queue.clear()
	for i in dialogue_data.dialogue_lines:
		text_queue.append(i)
		
	global.is_stop = true
	display_text()


func _process(_delta: float) -> void:
	match current_state:
		State.READY:
			pass
		State.READING:
			if Input.is_action_just_pressed("Interaction"):
				text.visible_ratio = 1.0
				tween.stop()
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("Interaction"):
				#change_state(State.READY)
				if text_queue.is_empty():
					finished_current_dialogue.emit()
					queue_free()
				else:
					start_symbol.text = ""
					text.text = ""
					end_symbol.text = ""
					
					display_text()


func queue_text(next_text):
	text_queue.push_back(next_text)


func hide_textbox():
	textbox_container.hide()
	background.hide()
	character_texture.hide()
	charater_name_container.hide()
	charater_name_label.text = ""
	start_symbol.text = ""
	text.text = ""
	end_symbol.text = ""


func show_textbox():
	textbox_container.show()
	background.show()
	character_texture.show()
	charater_name_container.show()
	start_symbol.text = "*"

func display_text():
	var next_text = text_queue.pop_front()
	text.text = next_text
	text.visible_ratio = 0.0
	change_state(State.READING)
	show_textbox()
	
	tween = create_tween()
	tween.tween_property(
		text, "visible_ratio", 1,
		len(next_text) * CHAR_READ_RATE
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	tween.finished.connect(Callable(self, "_on_tween_finished"))

func _on_tween_finished() -> void:
	change_state(State.FINISHED)
	end_symbol.text = "v"

func change_state(next_state):
	current_state = next_state
