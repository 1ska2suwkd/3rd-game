extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar
@onready var label = $Label

var health = 0 : set = _set_health

func _ready() -> void:
	var parent_node = get_parent()
	label.text = parent_node.get_name()

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		queue_free()
		label.queue_free()
		

	if health < prev_health:
		timer.start()
	else: # 체력이 채워지는 경우
		damage_bar.value = health 


func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health


func _on_timer_timeout() -> void:
	damage_bar.value = health
