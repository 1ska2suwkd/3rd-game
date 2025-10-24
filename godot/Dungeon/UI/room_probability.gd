extends Control


@onready var label = $CanvasLayer/Label

func _ready() -> void:
	if global.room_count == 5:
		label.text = "보스방: " + str(100 - int(global.probabilities[global.chest_room_stack]*100)) + "%\n상자방: " + str(int(global.probabilities[global.chest_room_stack]*100)) + "%"
	else:
		label.text = "보스방: 0%\n상자방: " + str(int(global.probabilities[global.chest_room_stack]*100)) + "%"
