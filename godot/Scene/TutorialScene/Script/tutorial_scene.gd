extends Node2D

@onready var PlayerUI = $Ysort/player/UI
@onready var StartAnimationCamera = $SceneStart/StartAnimationCamera
@onready var CameraAnimation = $SceneStart/AnimationPlayer

@onready var QuestUIAnimation = $Ysort/player/QuestUI/AnimationPlayer
@onready var QuestText = $Ysort/player/QuestUI/Ribbon/Ribbon/CenterContainer/Quest
@onready var HintText = $Ysort/player/QuestUI/Hint/HintText
@onready var Q1Hint = $Ysort/player/QuestUI/Hint/WASD
@onready var Q2Hint = $Ysort/player/QuestUI/Hint/MouseLeftClick
var master_textbox_scene = preload("res://Scene/Master/Master_Text_Box.tscn")

var QuestQueue = ["Q1", "Q2", "Q3"]


func _ready() -> void:
	QuestText.text = "1. 신보기를 움직여라" #첫번째 퀘스트 내용으로 초기화
	
	StartAnimationCamera.queue_free()
	
	var textbox = master_textbox_scene.instantiate()
	EventBus.connect("EndTextBox", Callable(self, "PlayAnimation"))
	PlayerUI.visible = false
	
	#CameraAnimation.play("SceneStart")
	#await CameraAnimation.animation_finished
	#CameraAnimation.play("CameraMove")
	#await CameraAnimation.animation_finished
	#StartAnimationCamera.queue_free()
	$StartScene.queue_free()
	textbox.queue_text("자 오늘은 마지막 수업이야~")
	textbox.queue_text("지금까지 배운 걸 전부 활용해서 나를 찾아봐!")
	get_tree().current_scene.add_child(textbox)

func PlayAnimation():
	var CurrentQuest = QuestQueue.pop_front()
	
	if CurrentQuest == "Q3":
		QuestUIAnimation.play("ChangeRibbonSize")
		await QuestUIAnimation.animation_finished
	
	QuestUIAnimation.play("ShowRibbon")
	await QuestUIAnimation.animation_finished
	QuestUIAnimation.play("Hint")


func _on_q_1_finished_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		QuestUIAnimation.play("finished_Quest")
		await  QuestUIAnimation.animation_finished
		Q1Hint.visible = false
	
		QuestText.text = "2. 공격으로 돌파하기"
		Q2Hint.visible = true
		$Trigger/Q1/Q1_finished.queue_free()


func _on_q_2_start_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var textbox = master_textbox_scene.instantiate()
		textbox.queue_text("공격하는 법을 까먹진 않았겠지?")
		textbox.queue_text("빨리 찾으러 와!")
		get_tree().current_scene.add_child(textbox)
		$Trigger/Q2/Q2_start.queue_free()


func _on_q_2_finished_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		QuestUIAnimation.play("finished_Quest")
		await  QuestUIAnimation.animation_finished
	
		QuestText.text = "3. 아이템을 획득하고 인벤토리를 확인하자!"
		$Trigger/Q2/Q2_finished.queue_free()


func _on_q_3_start_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var textbox = master_textbox_scene.instantiate()
		textbox.queue_text("잘하고있어! 이제 마지막 퀘스트야!")
		textbox.queue_text("화이팅~")
		get_tree().current_scene.add_child(textbox)
		$Trigger/Q3/Q3_start.queue_free()
