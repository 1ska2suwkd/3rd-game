extends Node2D

@export var health_component: HealthComponent
@onready var healthbar = $Healthbar

func _ready() -> void:
	health_component.change_hp.connect(update_healthbar)
	
func update_healthbar(hp):
	healthbar.health = hp
