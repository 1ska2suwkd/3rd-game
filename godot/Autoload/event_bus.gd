extends Node

#Stat
signal stats_changed()  # 현재 gd의 stats_changed()라는 함수 시그널 정의

#Text Box
signal EndTextBox()

#Enemy signal
signal target_enter_range()

#Inventory signal
signal update_inv_ui()

#Animation
signal show_hint_ui()
signal hide_hint_ui()

signal scene_transition_out(scene_path)
signal scene_transition_in()
