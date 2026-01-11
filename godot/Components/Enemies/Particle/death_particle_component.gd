extends Node2D

@export var death_component: DeathComponent
@export var death_particle: PackedScene


func _ready() -> void:
	death_component._die.connect(create_particle)
	
func create_particle():
	var ysort = get_tree().current_scene.get_node("Ysort")
	var instance = death_particle.instantiate()
	ysort.add_child(instance)
	instance.emitting = true
	instance.global_position = owner.global_position
	
	owner.queue_free()
