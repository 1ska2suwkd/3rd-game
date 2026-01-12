extends CanvasLayer

@onready var white_mouse: Sprite2D = $white_mouse
@onready var yellow_mouse: Sprite2D = $yellow_mouse

var cusor_color_white = true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _process(_delta: float) -> void:
	if cusor_color_white:
		white_mouse.visible = true
		white_mouse.position = white_mouse.get_viewport().get_mouse_position()
	else:
		yellow_mouse.visible = true
		yellow_mouse.position = yellow_mouse.get_viewport().get_mouse_position()
