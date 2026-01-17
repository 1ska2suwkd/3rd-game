extends Node2D

@export var interaction_component: InteractionComponent

@export var outline_material: ShaderMaterial
@export_custom(PROPERTY_HINT_NODE_TYPE, "Sprite2D,AnimatedSprite2D")
var sprite: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	outline_material.set_shader_parameter("outline_size", 3)
	sprite.material = null
	
	interaction_component.on_body_enter.connect(player_in)
	interaction_component.on_body_exit.connect(player_out)


func player_in() -> void:
	sprite.material = outline_material


func player_out() -> void:
	sprite.material = null
