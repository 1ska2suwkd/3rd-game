extends CanvasLayer

@onready var Scene_Animation = $AnimationTree

func _ready() -> void:
	EventBus.scene_transition_out.connect(Transition_Out)
	EventBus.scene_transition_in.connect(Transition_In)

func Transition_Out():
	Scene_Animation.play("transition_out")
	await Scene_Animation.animation_finished
	global.transition_scene = true
	global.is_stop = true

func Transition_In():
	Scene_Animation.play("transition_in")
	await Scene_Animation.animation_finished
	global.is_stop = false
