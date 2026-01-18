extends Node2D
# 대화가 끝난 이후에 변경되어야할 것이 있는 엔티티들이 사용하는 컴포넌트
# ex : 상점, 다시 대화 불가능

@export var talk_component: TalkComponent

func _ready() -> void:
	talk_component.conversation_finished.connect(open_store)


func open_store():
	print("open_store")
