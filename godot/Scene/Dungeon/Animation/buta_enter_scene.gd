extends CanvasLayer

@onready var EnterAnimation = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EnterAnimation.play("EnterAnimation")
	await EnterAnimation.animation_finished
	
	global.transition_scene = true
	global.is_stop = false
	global.change_scene("res://Scene/Dungeon/Room/Stage1_Boss.tscn")
