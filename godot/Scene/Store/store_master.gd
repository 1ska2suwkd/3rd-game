extends CharacterBody2D

@onready var outline_material := preload("res://Shaders/Outline.tres")
@onready var sprite := $AnimatedSprite2D

@export var interaction_component: InteractionComponent


func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	outline_material.set_shader_parameter("outline_size", 3)
	sprite.material = null
	interaction_component.on_body_enter.connect(player_in)
	interaction_component.on_body_exit.connect(player_out)
	
	
func player_in() -> void:
	EventBus.emit_signal("show_hint_ui")
	sprite.material = outline_material


func player_out() -> void:
	EventBus.emit_signal("hide_hint_ui")
	sprite.material = null
