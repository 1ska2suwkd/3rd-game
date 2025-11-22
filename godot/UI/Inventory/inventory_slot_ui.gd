extends Panel

@onready var item_visual : Sprite2D = $item_display
@onready var item_name_label = $Panel2/Panel/HBoxContainer/name
@onready var item_descript_label = $Panel2/Panel/HBoxContainer/descript
@onready var item_ability_label = $Panel2/Panel/HBoxContainer/ability
@onready var itme_descript_panel = $Panel2
@onready var not_item = $not_item
@onready var is_item = $is_item

func _ready() -> void:
	itme_descript_panel.visible = false
	

func update(item: Item):
	if !item:
		not_item.visible = true
		is_item.visible = false
		item_visual.visible = false
	else:
		not_item.visible = false
		is_item.visible = true
		item_visual.visible = true
		item_visual.texture = item.sprite
		item_name_label.text = item.item_name
		item_descript_label.text = item.item_description
		item_ability_label.text = item.item_ability

func _on_mouse_entered() -> void:
	itme_descript_panel.visible = true
func _on_mouse_exited() -> void:
	itme_descript_panel.visible = false
