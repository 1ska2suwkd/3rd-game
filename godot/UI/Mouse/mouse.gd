extends CanvasLayer

@onready var white_mouse: Sprite2D = $white_mouse
@onready var yellow_mouse: Sprite2D = $yellow_mouse

#func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _process(_delta: float) -> void:
	white_mouse.position = white_mouse.get_viewport().get_mouse_position()
