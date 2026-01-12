extends Node2D

@onready var speer_animation: AnimationPlayer = $speer_animation
@onready var sprite: Node2D = $sprite
@onready var speer: Node2D = $"."

func _ready() -> void:
	speer.rotation_degrees += randf_range(-10, 10)
