extends Node2D

@onready var 개종_collision = $Ysort/개종/InteractionComponent/InteractionCollision
@onready var Void: CharacterBody2D = $Ysort/Void

func _ready() -> void:
	개종_collision.disabled = true
	Void.get_node("TalkComponent").conversation_finished.connect(on_VoidTalk_a_finished)
	
func on_VoidTalk_a_finished():
	개종_collision.disabled = false
	
