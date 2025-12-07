extends Node2D

@onready var PlayerUI = $Ysort/player/UI
@onready var StartAnimationCamera = $SceneStart/StartAnimationCamera
@onready var CameraAnimation = $SceneStart/AnimationPlayer

@onready var Q1Animation = $Ysort/player/Q1/AnimationPlayer
var master_textbox = preload("res://Scene/StartScene/Master/Master_Text_Box.tscn").instantiate()

func _ready() -> void:
	StartAnimationCamera.queue_free()
	
	master_textbox.is_skilltree = false
	EventBus.connect("EndTextBox", Callable(self, "PlayAnimation"))
	PlayerUI.visible = false
	
	#CameraAnimation.play("SceneStart")
	#await CameraAnimation.animation_finished
	#CameraAnimation.play("CameraMove")
	#await CameraAnimation.animation_finished
	#StartAnimationCamera.queue_free()
	master_textbox.queue_text("자 오늘은 마지막 수업이야~")
	master_textbox.queue_text("지금까지 배운 걸 전부 활용해서 나를 찾아봐!")
	get_tree().current_scene.add_child(master_textbox)

func PlayAnimation():
	Q1Animation.play("ShowRibbon")
	await Q1Animation.animation_finished
	Q1Animation.play("Hint")
