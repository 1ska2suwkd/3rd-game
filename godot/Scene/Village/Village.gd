extends Node2D

@onready var outline_material := preload("res://UI/Outline.tres")
@onready var Master_sprite := $Ysort/Master/StaticBody2D/Master_Animation
@onready var Dungeon_sprite := $Dungeon/Dungeon
@onready var Store_sprite := $Ysort/Store/store

@export var player: CharacterBody2D
var master_textbox_scene = preload("res://UI/TextBox/Master/Master_Text_Box.tscn")


var ready_store = false

func _ready() -> void:
	if global.first_enter_village:
		
		player.get_node("AnimatedSprite2D").flip_h = true
		player.global_position = global.MASTER_FRONT
		
		var master_textbox = master_textbox_scene.instantiate()
		master_textbox.queue_text("우리 마을.. 원래는 시끌시끌하고 강한 사람도 많았는데...")
		master_textbox.queue_text("[color=red]그 녀석들[color=white]이 마을을 떠난 이후로 중앙통제구역의 몬스터들은 눈치 볼 게 없어진 거야.")
		master_textbox.queue_text("곧바로 마을을 습격하고 사람들을 납치했어.\n중앙통제구역에서 부려먹을려고 데려간 걸거야!")
		master_textbox.queue_text("시간이 없어 너가 모두를 구해야해!")
		master_textbox.queue_text("... 나는 뭐하고있을 거냐고?")
		master_textbox.queue_text("미안하지만 난 이제 할 짬이 아니야.")
		master_textbox.queue_text("나도 시간이 얼마 안남았다고!\n그래서 2주동안 널 열심히 가르친거야.")
		master_textbox.queue_text("어쨌든 [color=red]던전은 우리 마을 북쪽에 있어")
		master_textbox.queue_text("던전에서 재료를 가져오면 [color=red]너에게 나의 마지막 기술을 알려줄게")
		master_textbox.queue_text("신보기.. 행운을 빌게")
		get_tree().current_scene.add_child(master_textbox)
		
		global.first_enter_village = false
	else:
		#player 위치정보 불러오기
		player.global_position = global.player_next_position
		global.player_next_position = Vector2.ZERO
		
		#player 스프라이트 방향 불러오기 [있는 경우에만]
		if not global.player_flip_h == null:
			var player_animated_sprite = player.get_node_or_null("AnimatedSprite2D")
			if player_animated_sprite:
				player_animated_sprite.flip_h = global.player_flip_h
				global.player_flip_h = null
			
		
	outline_material.set_shader_parameter("outline_size", 3)
	Master_sprite.material = null

func _process(_delta):
	if global.transition_scene:
		if Input.is_action_just_pressed("Interaction"):
			SceneManager.change_scene("res://Scene/Dungeon/Room/Room0.tscn")
	elif ready_store:
		pass

# Dungeon 메서드
func _on_area_2d_body_entered(body): 
	if body.is_in_group("player"):
		global.transition_scene = true
		Dungeon_sprite.material = outline_material
func _on_area_2d_body_exited(body: Node2D) -> void:
	if Input.is_action_just_pressed("Interaction"): return
	if body.is_in_group("player"):
		global.transition_scene = false
		Dungeon_sprite.material = null
		



# Store 메서드
func _on_entered_store_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ready_store = true
		Store_sprite.material = outline_material
func _on_entered_store_body_exited(body: Node2D) -> void:
	if Input.is_action_just_pressed("Interaction"): return
	if body.is_in_group("player"):
		ready_store = false
		Store_sprite.material = null
		
