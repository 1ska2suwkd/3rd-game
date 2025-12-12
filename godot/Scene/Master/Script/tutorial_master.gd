extends Node2D

@onready var outline_material := preload("res://UI/Outline.tres")
@onready var Master_sprite := $StaticBody2D/Master_Animation


var ready_master = false
var ready_store = false

func _ready() -> void:
	outline_material.set_shader_parameter("outline_size", 3)
	Master_sprite.material = null
	

func _process(_delta):
	$StaticBody2D/Master_Animation.play("idle")
	
	if ready_master:
		if Input.is_action_just_pressed("Interaction") and not global.is_stop:
			var master_textbox = preload("res://Scene/Master/Master_Text_Box.tscn").instantiate()
			master_textbox.is_skilltree = false
			master_textbox.queue_text("안녕")
			master_textbox.queue_text("강력한 기술을 배우고싶지?")
			get_tree().current_scene.add_child(master_textbox)
	
func _on_talk_to_master_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ready_master = true
		Master_sprite.material = outline_material
		
func _on_talk_to_master_body_exited(body: Node2D) -> void:
	if Input.is_action_just_pressed("Interaction"): return
	if body.is_in_group("player"):
		ready_master = false
		Master_sprite.material = null
