extends Node2D

var INVENTORY_SIZE = 16

@onready var PlayerUI = $Ysort/player/UI/PlayerUI
@onready var StartAnimationCamera = $SceneStart/StartAnimationCamera
@onready var CameraAnimation = $SceneStart/AnimationPlayer

@onready var QuestUIAnimation = $QuestUI/AnimationPlayer
@onready var QuestText = $QuestUI/Ribbon/Ribbon/CenterContainer/Quest
@onready var HintText = $QuestUI/Hint/HintUI/HintText
@onready var WASD = $QuestUI/Hint/HintUI/CenterContainer/WASD
@onready var MouseLeftClick = $QuestUI/Hint/HintUI/CenterContainer/MouseLeftClick
@onready var E = $QuestUI/Hint/HintUI/CenterContainer/E
var master_textbox_scene = preload("res://Scene/Master/Master_Text_Box.tscn")

var QuestQueue = ["Q1", "Q2", "Q3"]


func _ready() -> void:
	QuestText.text = "1. 신보기를 움직여라" #첫번째 퀘스트 내용으로 초기화
	
	#StartAnimationCamera.queue_free()
	
	var textbox = master_textbox_scene.instantiate()
	EventBus.connect("EndTextBox", Callable(self, "PlayAnimation"))
	PlayerUI.visible = false
	
	CameraAnimation.play("SceneStart")
	await CameraAnimation.animation_finished
	CameraAnimation.play("CameraMove")
	await CameraAnimation.animation_finished
	StartAnimationCamera.queue_free()
	
	$StartScene.queue_free()
	textbox.queue_text("자 오늘은 마지막 수업이야~")
	textbox.queue_text("지금까지 배운 걸 전부 활용해서 나한테 와!")
	get_tree().current_scene.add_child(textbox)
	
func _process(_delta: float) -> void:
	# 플레이어의 인벤토리에는 배열의 크기만큼 NULL이 들어가있음 
	# 플레이어가 아이템을 하나 먹으면 NULL의 숫자가 1 줄어드는 성질을 이용함
	if PlayerStat.player_inv.items.count(null) < INVENTORY_SIZE and Input.is_action_just_pressed("E"):
		if $Ysort/Door.animation != "open":
			$Ysort/Door.play("open")
			$Ysort/Door/StaticBody2D/CollisionPolygon2D.disabled = true

func PlayAnimation():
	if not QuestQueue.is_empty():
		var CurrentQuest = QuestQueue.pop_front()
		
		if CurrentQuest == "Q3":
			QuestUIAnimation.play("ChangeRibbonSize")
			await QuestUIAnimation.animation_finished
		
		QuestUIAnimation.play("ShowTutorialUI")


func _on_q_1_finished_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		QuestUIAnimation.play("finished_Quest")
		await  QuestUIAnimation.animation_finished
		WASD.visible = false
	
		QuestText.text = "2. 공격으로 돌파하기"
		MouseLeftClick.visible = true
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
		MouseLeftClick.visible = false
	
		QuestText.text = "3. 아이템을 획득하고 인벤토리를 확인하자!"
		E.visible = true
		$Trigger/Q2/Q2_finished.queue_free()


func _on_q_3_start_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var textbox = master_textbox_scene.instantiate()
		textbox.queue_text("잘하고있어! 이제 마지막 퀘스트야!")
		textbox.queue_text("화이팅~")
		get_tree().current_scene.add_child(textbox)
		$Trigger/Q3/Q3_start.queue_free()


func _on_q_3_finished_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		QuestUIAnimation.play("finished_Quest")
		
		# 물리 리스트를 순회하면서 처리하기 때문에 body가 entered 하는 타이밍과 비슷하게 disabled를 false 하면
		# 안전을 위해 godot에서 오류를 발생함 그렇기 때문에 set_deferred를 사용
		$Ysort/Door/StaticBody2D/CollisionPolygon2D.set_deferred("disabled", false)
		$Ysort/Door.play("close")
		
		$Trigger/Q3/Q3_finished.queue_free()
