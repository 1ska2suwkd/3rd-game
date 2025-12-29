extends Node2D
class_name HealthComponent

var hp = 0
var stats: EnemyStat:
	set(new_stats):
		stats = new_stats
		if stats:
			hp = stats.max_hp


func damage(p_damage):
	hp -= p_damage
	if hp <= 0:
		pass
		#시그널 넣어서 DeathComponent 랑 연결 필요
