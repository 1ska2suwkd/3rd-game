extends CanvasLayer

@onready var damage = $VBoxContainer2/HBoxContainer3/Damage
@onready var attack_speed = $VBoxContainer2/HBoxContainer4/attack_speed
@onready var attack_range = $VBoxContainer2/HBoxContainer5/range
@onready var gold = $HBoxContainer4/current_gold

func _ready() -> void:
	update_labels()
	EventBus.connect("stats_changed", Callable(self, "update_labels")) # stat_changed 함수와 연결해서 시그널이 오면 update_labels를 실행


func update_labels():
	damage.text = str(PlayerStat.damage)
	attack_speed.text = str(PlayerStat.attack_speed)
	attack_range.text = str(PlayerStat.attack_range)
	gold.text = str(PlayerStat.gold)
