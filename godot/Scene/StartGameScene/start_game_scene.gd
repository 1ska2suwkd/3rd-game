extends CanvasLayer

@onready var game_start_text = $game_start/gmae_start_text
@onready var settings_text = $settings/settings_text
@onready var quit_text = $quit/quit_text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Node2D/AnimatedSprite2D.play("idle")
	$Node2D/AnimatedSprite2D2.play("idle")


func button_down_text_setting(text_name):
	text_name.modulate = Color(Color(1.0, 1.0, 1.0, 0.667))
	text_name.position.y += 3
func button_up_text_setting(text_name):
	text_name.modulate = Color(Color(1.0, 1.0, 1.0, 1.0))
	text_name.position.y -= 3


func _on_game_start_button_down() -> void:
	button_down_text_setting(game_start_text)
func _on_game_start_button_up() -> void:
	button_up_text_setting(game_start_text)


func _on_settings_button_down() -> void:
	button_down_text_setting(settings_text)
func _on_settings_button_up() -> void:
	button_up_text_setting(settings_text)


func _on_quit_button_down() -> void:
	button_down_text_setting(quit_text)
func _on_quit_button_up() -> void:
	button_up_text_setting(quit_text)
