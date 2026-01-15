extends Node2D

@onready var gold: AnimatedSprite2D = $Deco/Gold
@onready var rubber_duck: AnimatedSprite2D = $Deco/Rubber_duck


func _ready() -> void:
	gold.play("idle")
	rubber_duck.play("idle")
