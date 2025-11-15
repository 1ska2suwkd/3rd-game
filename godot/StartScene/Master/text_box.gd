extends CanvasLayer

const CHAR_READ_RATE = 0.1

var tween

@onready var textbox_container = $TextboxContainer
@onready var background = $ColorRect
@onready var master = $NinePatchRect
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


func _process(_delta: float) -> void:
	match current_state:
		State.READY:
			if not text_queue.is_empty():
				global.is_stop = true
				display_text()
		State.READING:
			if Input.is_action_just_pressed("Interaction"):
				text.visible_ratio = 1.0
				tween.stop()
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("Interaction"):
				change_state(State.READY)
				if text_queue.is_empty():
					hide_textbox()
					#global.is_stop = false
					var master_skilltree = preload("res://StartScene/Master/Master_Skilltree.tscn").instantiate()
					get_tree().current_scene.add_child(master_skilltree)
				else:
					start_symbol.text = ""
					text.text = ""
					end_symbol.text = ""


func queue_text(next_text):
	text_queue.push_back(next_text)


func hide_textbox():
	textbox_container.hide()
	background.hide()
	master.hide()
	start_symbol.text = ""
	text.text = ""
	end_symbol.text = ""


func show_textbox():
	textbox_container.show()
	background.show()
	master.show()
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
