extends Control

@onready var slots: Array = $GridContainer.get_children()

var is_open = false

func _ready() -> void:
	update_slots()
	EventBus.connect("update_inv_ui",Callable(self, "update_slots"))
	close()
	
	
func update_slots():
	for i in range(min(PlayerStat.player_inv.items.size(), slots.size())):
		slots[i].update(PlayerStat.player_inv.items[i])
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("E"):
		if is_open:
			close()
		else:
			open()
	
func open():
	visible = true
	is_open = true
	
	
func close():
	visible = false
	is_open = false
