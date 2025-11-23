extends Area2D

#@export var exdata: Resource
@onready var Sprite = $Sprite2D
var item_number: int
var item_data: Resource
var item_script

#func _ready() -> void:
	#Setup(exdata)

func Setup(data: Resource):
	item_data = data
	
	Sprite.texture = item_data.sprite
	item_number = item_data.item_number
	if item_data.effect_script:
		item_script = item_data.effect_script.new()

func use_item():
	if item_script:
		item_script.apply()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		PlayerStat.player_inv.items[item_number] = item_data
		EventBus.emit_signal("add_item")
		use_item()
		queue_free()
