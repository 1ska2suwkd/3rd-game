extends Panel

@export var interaction_component: InteractionComponent

func _ready() -> void:
	$".".modulate.a = 0.0
	interaction_component.on_body_enter.connect(showUI)
	interaction_component.on_body_exit.connect(hideUI)

func showUI():
	$AnimationPlayer.play("show")

func hideUI():
	$AnimationPlayer.play("hide")
