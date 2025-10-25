extends CanvasLayer

@onready var damage = $"../UI/VBoxContainer/HBoxContainer3/Damage"
@onready var attack_speed = $"../UI/VBoxContainer/HBoxContainer4/attack_speed"

func _ready() -> void:
	damage.text = str(PlayerStat.damage)
	attack_speed.text = str(PlayerStat.attack_speed)
