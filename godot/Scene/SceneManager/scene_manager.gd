extends CanvasLayer

@onready var Scene_Animation:AnimationPlayer = $AnimationTree


func change_scene(scene_path):
	global.is_stop = true
	Scene_Animation.play("transition_out")
	await Scene_Animation.animation_finished
	global.transition_scene = true
	
	global.change_scene(scene_path)
	Scene_Animation.play("transition_in")
	await Scene_Animation.animation_finished
	global.is_stop = false
	Scene_Animation.play("RESET")
	
