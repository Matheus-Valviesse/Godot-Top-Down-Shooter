extends Resource
class_name Skill

var name: String
var mana_cost: int
var damage_multiplier: float

var damage

func _init(_name: String, _mana_cost: int, _damage_multiplier: float) -> void:
	name = _name
	mana_cost = _mana_cost
	damage_multiplier = _damage_multiplier

func _call_skill(player, dmg):


	if player.MP >= mana_cost:
		player.MP -= mana_cost
		apply_skill(player, dmg)

	damage = dmg


func apply_skill(player, dmg) -> void:
	pass
