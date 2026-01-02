extends Node

signal stats_changed()  # 현재 gd의 stats_changed()라는 함수 시그널 정의
signal update_inv_ui()
signal EndTextBox()

#enemy signal
signal target_enter_range()

#Ui signal
signal show_hint_ui()
signal hide_hint_ui()
