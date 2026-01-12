extends Node2D

@onready var speer_animation: AnimationPlayer = $speer_animation

func _ready() -> void:
	#speer_animation.play("spawn_speer")
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interaction"):
		speer_animation.play("spawn_speer")
