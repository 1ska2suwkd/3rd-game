# LoadingScreen.gd
extends Control

var target_scene_path = "res://Scene/IntroScene/IntroScene.tscn"
var progress = []
var particles_to_cache = [
	preload("res://Particle/EnemyDeadParticle.tscn"),
	preload("res://Particle/GrassParticle.tscn"),
	preload("res://Particle/BoxParticle.tscn")
]

	
func _ready():
	# 1. 리소스 로딩 시작
	ResourceLoader.load_threaded_request(target_scene_path)
	
	# 2. 파티클 프리캐싱 (여기서 실행!)
	await pre_render_shaders()

func _process(_delta):
	# 3. 로딩 상태 확인
	var status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
	
	# 로딩바 업데이트 (progress[0]은 0.0 ~ 1.0 값)
	#$ProgressBar.value = progress[0] * 100
	
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		# 로딩 완료 시 씬 교체
		var new_scene = ResourceLoader.load_threaded_get(target_scene_path)
		get_tree().change_scene_to_packed(new_scene)
		

func pre_render_shaders():
	for p in particles_to_cache:
		var instance = p.instantiate()
		instance.position = Vector2(-9999, -9999) # 화면 밖
		add_child(instance)
		# GPUParticles2D라면 emitting을 true로 해서 셰이더를 강제로 태웁니다.
		if instance is GPUParticles2D:
			instance.emitting = true 
			
		# 아주 짧은 시간 뒤에 삭제 (혹은 셰이더가 컴파일될 시간 확보)
		await get_tree().create_timer(0.1).timeout
		instance.queue_free()
		print(p)
