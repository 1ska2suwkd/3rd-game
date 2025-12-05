extends CanvasLayer

const CHAR_READ_RATE = 0.1

var tween

@onready var end_symbol = $End
@onready var text = $RichTextLabel

enum State{
	READY,
	READING,
	FINISHED
}

var text_queue = []
var current_state = State.READY

func _ready() -> void:
	queue_text("[color=red]\"중앙통제구역\"")
	queue_text("그 곳을 알고있는 사람들은 이렇게 말한다.")
	queue_text("[color=red]중앙통제구역에서 일어난 모든 일은 \n외부로 유출하지 않으며")
	queue_text("[color=red]항상 긴장하며 주위를 살펴라")
	queue_text(". . .")
	queue_text("[color=white]이것은 그 곳에서 무슨 일이 \n일어났는지에 대한 이야기이다.")
	
	#queue_text("[color=red]중앙통제구역 규칙")
	#queue_text("1. 이 곳에서 일어난 모든 일을 외부로 유출하지 않을 것")
	#queue_text("2. 항상 긴장하며 사주경계를 실시할 것")


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
					global.transition_scene = true
					global.change_scene("res://Scene/TutorialScene/TutorialScene.tscn")
				else:
					text.text = ""
					end_symbol.text = ""


func queue_text(next_text):
	text_queue.push_back(next_text)


func hide_textbox():
	text.text = ""
	end_symbol.text = ""



func display_text():
	var next_text = text_queue.pop_front()
	text.text = next_text
	text.visible_ratio = 0.0
	change_state(State.READING)
	
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
