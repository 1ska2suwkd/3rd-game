extends CanvasLayer

@onready var Check = $Check
var is_buy = false

func _ready() -> void:
	Check.hide()


func _on_buy_skill_pressed() -> void:
	if not is_buy and PlayerStat.gold >= 10:
		is_buy = true
		PlayerStat.set_gold(-10)
		MasterSkill.Crescent_Slash = true
		Check.show()

func _on_exit_button_pressed() -> void:
	queue_free()
	global.is_reading = false
