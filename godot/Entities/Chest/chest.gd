extends StaticBody2D

@export var interaction_component: InteractionComponent

@onready var chest: AnimatedSprite2D = $Chest
@onready var item_scene = preload("res://Resources/Items/Scene/ItemScene.tscn")
@onready var open_animation: AnimationPlayer = $open_animation


var opend = false

func _ready() -> void:
	interaction_component.press_interaction.connect(OpenChest)


func OpenChest():
	if opend:	return
	opend = true
	
	# interaction_component 연결해제 (쉐이더, 힌트 UI 삭제)
	interaction_component.on_body_exit.emit()
	interaction_component.queue_free()
	
	var item = item_scene.instantiate()
	var ysort = get_tree().current_scene.get_node("Ysort")
	
	item.global_position = global_position
	item.global_position.y += -50
	ysort.add_child(item)
	
	# 아이템 등급이 레전드리면 에픽빔
	if not item.item_data.item_grade == item.item_data.ItemGrade.LEGENDARY:
		open_animation.play("open_chest")
		await open_animation.animation_finished
	elif item.item_data.item_grade == item.item_data.ItemGrade.LEGENDARY:
		open_animation.play("epic_open_chest")
		await open_animation.animation_finished
	
