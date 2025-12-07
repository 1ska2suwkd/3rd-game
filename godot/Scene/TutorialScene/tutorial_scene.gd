extends Node2D

@onready var PlayerUI = $Ysort/player/UI
@onready var StartAnimationCamera = $StartAnimationCamera
@onready var CameraAnimation = $AnimationPlayer

func _ready() -> void:
	PlayerUI.visible = false
	CameraAnimation.play("SceneStart")
	await CameraAnimation.animation_finished
	CameraAnimation.play("CameraMove")
	await CameraAnimation.animation_finished
	
	#StartAnimationCamera.queue_free()
