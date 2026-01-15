extends Resource
class_name Item

enum ItemGrade {
	COMMON,
	RARE,
	EPIC,
	UNIQUE,
	LEGENDARY
}

@export var item_number : int = 0
@export var item_grade : ItemGrade
@export var item_name : String = ""
@export var item_description : String = ""
@export var item_ability : String = ""
@export var effect_script : Script
@export var item_inventory_texture : Texture2D
@export var item_ingame_texture : Texture2D
