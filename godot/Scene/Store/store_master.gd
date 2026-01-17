extends CharacterBody2D

@export var dialogue_data: DialogueData

@onready var outline_material := preload("res://Shaders/Outline.tres")
@onready var sprite := $AnimatedSprite2D


var ready_talk = false
var ready_store = false

func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	outline_material.set_shader_parameter("outline_size", 3)
	sprite.material = null
	

func _process(_delta):
	
	if ready_talk:
		if Input.is_action_just_pressed("Interaction") and not global.is_stop:
			var textbox = preload("res://UI/TextBox/Text_Box_UI.tscn").instantiate()
			textbox.dialogue_data = preload("res://Resources/DialogueData/Pex.tres")
			
			get_tree().current_scene.add_child(textbox)
	
func _on_talk_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ready_talk = true
		EventBus.emit_signal("show_hint_ui")
		sprite.material = outline_material


func _on_talk_area_body_exited(body: Node2D) -> void:
	if Input.is_action_just_pressed("Interaction"): return
	if body.is_in_group("player"):
		EventBus.emit_signal("hide_hint_ui")
		ready_talk = false
		sprite.material = null
