extends Panel

func _ready() -> void:
	EventBus.show_hint_ui.connect(showUI)
	EventBus.hide_hint_ui.connect(hideUI)

func showUI():
	$AnimationPlayer.play("show")

func hideUI():
	$AnimationPlayer.play("hide")
