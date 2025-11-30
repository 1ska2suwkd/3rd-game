extends CanvasLayer

@onready var EnterAnimation = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EnterAnimation.play("EnterAnimation")
	await EnterAnimation.animation_finished
	
	global.change_scene("res://Dungeon/Room/Stage1_Boss.tscn")
