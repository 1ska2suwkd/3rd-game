extends Node2D

@onready var PlayerUI = $Ysort/player/UI
@onready var StartAnimationCamera = $SceneStart/StartAnimationCamera
@onready var CameraAnimation = $SceneStart/AnimationPlayer

@onready var Q1Animation = $Ysort/player/Q1/AnimationPlayer
@onready var QuestText = $Ysort/player/Q1/Ribbon/Quest
@onready var HintText = $Ysort/player/Q1/Hint/HintText
@onready var Q1Hint = $Ysort/player/Q1/Hint/WASD
var master_textbox = preload("res://Scene/StartScene/Master/Master_Text_Box.tscn").instantiate()

var Q1 = true
var Q2 = true
var Q3 = true

func _ready() -> void:
	QuestText.text = "1. 신보기를 움직여라" #첫번째 퀘스트 내용으로 초기화
	
	StartAnimationCamera.queue_free()
	
	master_textbox.is_skilltree = false
	EventBus.connect("EndTextBox", Callable(self, "PlayAnimation"))
	PlayerUI.visible = false
	
	#CameraAnimation.play("SceneStart")
	#await CameraAnimation.animation_finished
	#CameraAnimation.play("CameraMove")
	#await CameraAnimation.animation_finished
	#StartAnimationCamera.queue_free()
	master_textbox.queue_text("자 오늘은 마지막 수업이야~")
	master_textbox.queue_text("지금까지 배운 걸 전부 활용해서 나를 찾아봐!")
	get_tree().current_scene.add_child(master_textbox)

func PlayAnimation():
	Q1Animation.play("ShowRibbon")
	await Q1Animation.animation_finished
	Q1Animation.play("Hint")
	#if Q1:
		#Q1Animation.play("ShowRibbon")
		#await Q1Animation.animation_finished
		#Q1Animation.play("Hint")
	#elif Q2:
		#pass
	#elif Q3:
		#pass


func _on_q_1_finished_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and Q1:
		Q1 = false
		Q1Animation.play("finished_Q1")
		await  Q1Animation.animation_finished
		Q1Hint.visible = false
	
		QuestText.text = "2. 공격으로 돌파하기"
		HintText.text = "마우스 왼쪽 클릭"


func _on_q_2_start_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and Q2:
		master_textbox.queue_text("공격하는 법을 까먹진 않았겠지?")
		master_textbox.queue_text("빨리 찾으러 와!")
		get_tree().current_scene.add_child(master_textbox)
		Q2 = false
