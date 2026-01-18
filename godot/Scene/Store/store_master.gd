extends CharacterBody2D

@export var talk_component: TalkComponent

func _ready() -> void:
	pass
	talk_component.conversation_finished.connect(open_store)

func open_store():
	print("open_store")
