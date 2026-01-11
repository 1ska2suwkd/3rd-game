extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Node2D/AnimatedSprite2D.play("idle")
	$Node2D/AnimatedSprite2D2.play("idle")
