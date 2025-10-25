extends Control


@onready var boss = $CanvasLayer/VBoxContainer/HBoxContainer/Boss
@onready var chest = $CanvasLayer/VBoxContainer/HBoxContainer2/Chest


func _ready() -> void:
	if global.room_count == 5:
		boss.text = str(100 - int(global.probabilities[global.chest_room_stack]*100)) + "%"
	chest.text = str(int(global.probabilities[global.chest_room_stack]*100)) + "%"
