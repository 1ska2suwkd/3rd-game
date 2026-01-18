extends Node2D

@export var talk_component: TalkComponent

func _ready() -> void:
	talk_component.conversation_finished.connect(open_skill_tree)

func open_skill_tree():
	print("open skill tree")
