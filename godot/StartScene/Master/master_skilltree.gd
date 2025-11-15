extends CanvasLayer

@onready var Check = $Check
@onready var buy_text = $Buy_Skill/Buy_text

var is_buy = false

func _ready() -> void:
	if MasterSkill.Crescent_Slash:
		Check.show()
	else: 
		Check.hide()


func _on_buy_skill_pressed() -> void:
	if not is_buy and PlayerStat.gold >= 10:
		is_buy = true
		PlayerStat.set_gold(-10)
		MasterSkill.Crescent_Slash = true
		PlayerStat.player_inv.items[0] = MasterSkill.Crescent_Slash_item
		Check.show()

func _on_buy_skill_button_down() -> void:
	buy_text.modulate = Color(Color(1.0, 1.0, 1.0, 0.667))
	buy_text.position.y = 13

func _on_buy_skill_button_up() -> void:
	buy_text.modulate = Color(Color(1.0, 1.0, 1.0))
	buy_text.position.y = 9
	

func _on_exit_button_pressed() -> void:
	queue_free()
	global.is_stop = false
	PlayerStat.attacking = false
