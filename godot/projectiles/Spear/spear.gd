extends Node2D

@onready var spear_animation: AnimationPlayer = $spear_animation
@onready var sprite: Node2D = $sprite
@onready var spear: Node2D = $"."

func _ready() -> void:
	spear.rotation_degrees += randf_range(-10, 10)
	$sprite/SpearShadow.global_rotation = 0.0
