extends Area2D

#@export var exdata: Resource
@onready var Sprite = $CollisionShape2D/Sprite2D
@onready var spawn_animation = $AnimationPlayer
var item_number: int
var item_data: Resource
var item_script

func _ready() -> void:
	randomize()

	Setup()

func Setup():
	#var RandomItemNumber = randi_range(0,4)
	var RandomItemNumber = 0
	
	item_data = AllItem.all_item[RandomItemNumber]
	
	Sprite.texture = item_data.sprite
	item_number = item_data.item_number
	if item_data.effect_script:
		item_script = item_data.effect_script.new()
		
	spawn_animation.play("ItemSpawn")
	await spawn_animation.animation_finished
	
	spawn_animation.play("idle")

func use_item():
	PlayerStat.player_inv.items[item_number] = item_data
	if item_script:
		item_script.apply()
	queue_free()
