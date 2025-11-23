extends StaticBody2D

@onready var outline_material := preload("res://UI/Outline.tres")
@onready var sprite := $AnimatedSprite2D
@onready var inItem = preload("res://Resources/Items/Scene/ItemScene.tscn").instantiate()

var ready_open = false
var opend = false

func _ready() -> void:
	outline_material.set_shader_parameter("outline_size", 1)
	sprite.material = null


func _process(_delta: float) -> void:
	if opend: return
	
	if ready_open and Input.is_action_just_pressed("Interaction"):
		OpenChest()

func OpenChest():
	$AnimatedSprite2D.play("open")
	await $AnimatedSprite2D.animation_finished
	sprite.material = null
	opend = true
	
	inItem.global_position = global_position
	get_tree().current_scene.add_child(inItem)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not opend:
		ready_open = true
		sprite.material = outline_material


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and not opend:
		ready_open = false
		sprite.material = null
