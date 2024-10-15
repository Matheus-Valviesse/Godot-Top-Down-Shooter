extends Resource
class_name Skill

var name : String
var mana_cost : int

func _init(_name:String, _mana_cost:int) -> void:
	name = _name
	mana_cost = _mana_cost

func _call_skill (player):


	if player.MP >= mana_cost:
		player.MP -= mana_cost
		apply_skill(player)
	else:
		print('mana insuficiente')


func apply_skill(player) -> void:
	pass