extends StaticBody2D

@onready var outline_material := preload("res://UI/Outline.tres")
@onready var chest: AnimatedSprite2D = $Chest
@onready var item_scene = preload("res://Resources/Items/Scene/ItemScene.tscn")
@onready var open_animation: AnimationPlayer = $open_animation


var ready_open = false
var opend = false

func _ready() -> void:
	outline_material.set_shader_parameter("outline_size", 1)
	chest.material = null


func _process(_delta: float) -> void:
	if opend: return
	
	if ready_open and Input.is_action_just_pressed("Interaction"):
		OpenChest()

func OpenChest():
	if opend:	return
	#opend = true
	EventBus.emit_signal("hide_hint_ui")
	
	chest.material = null
	
	var item = item_scene.instantiate()
	var ysort = get_tree().current_scene.get_node("Ysort")
	
	item.global_position = global_position
	item.global_position.y += -50
	ysort.add_child(item)
	
	open_animation.play("open_chest")
	await open_animation.animation_finished
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not opend:
		ready_open = true
		EventBus.emit_signal("show_hint_ui")
		chest.material = outline_material


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and not opend:
		ready_open = false
		EventBus.emit_signal("hide_hint_ui")
		chest.material = null
