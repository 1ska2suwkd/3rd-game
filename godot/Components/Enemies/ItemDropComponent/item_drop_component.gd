extends Node2D

@export var death_component: DeathComponent
@export var drop_item_list: Array[PackedScene]
@export var drop_chance: float = 0.5


func _ready() -> void:
	death_component._die.connect(drop_item)
	
func drop_item():
	var ysort = get_tree().current_scene.get_node("Ysort")
	
	if randf() > drop_chance:
		return
		
	var item_scene = drop_item_list.pick_random()
	if item_scene == null:
		return
	
	var item_instance = item_scene.instantiate()
	
	
	item_instance.global_position = owner.global_position
	ysort.call_deferred("add_child", item_instance)
