extends CharacterBody2D

var HP: float = 1000
var HPMax: float = 1000

var ATK: float = 500
var ATKMax: float = 0

var DEF: float = 300
var DEFMax: float = 0

var SPEED: float = 180
var SPEEDMax: float = 0

var CRIT: float = 0.15
var CRITMax: float = 0.50

var CRITDmg: float = 0.15
var CRITDmgMax: float = 0.50

var status_effects: Array = []
var status_bonus: Array = []
var status_item: Array = []

@onready var arm = $Arm
@onready var hand = $Arm/Hand

var type_entity: String = 'enemy'

func get_entity() -> String:
	return type_entity

func _physics_process(delta: float) -> void:

	for i in range(status_effects.size()):
		var effect = status_effects[i]
		effect.duration -= delta

		if effect.has_method('apply_in_time'):
			effect.apply_in_time(delta, self)
			if effect.duration < 0:
				apply_bonus(effect.get_effect_name(), 'remove')
				effect.remove(self)
				status_effects.remove_at(i)
				break

func apply_status_effect(effect) -> void:
	var effect_exist: bool = false
	for exist in range(status_effects.size()):
		effect_exist = status_effects[exist].get_effect_name() == effect.get_effect_name()

		if effect_exist:

			apply_bonus(status_effects[exist].get_effect_name(), 'remove')
			for i in range(status_effects.size()):
				if status_effects[i].get_effect_name() == effect.get_effect_name():
					status_effects[i].duration = effect.duration

			for i in range(status_bonus.size()):
				if status_bonus[i].name == effect.get_effect_name() and status_bonus[i].values.COUNT < effect.count_max:
					status_bonus[i].values.COUNT += KEY_1
					apply_bonus(status_effects[exist].get_effect_name(), 'apply')
					return

		status_effects.append(effect)
		effect.apply(self)
	apply_bonus(effect.get_effect_name(), 'apply')

func apply_bonus(statuName: String, type: String) -> void:
	if type:
			for i in range(status_bonus.size()):
				if status_bonus[i].name == statuName:
					for value in range(status_bonus[i].values.size()):
						var statu_name = status_bonus[i].values.keys()[value]
						var statu_value = status_bonus[i].values.values()[value]
						var statu_count = status_bonus[i].values.COUNT
						var prev_value = get(statu_name)

						if prev_value:
							if type == 'apply':
								var next_value = prev_value + (statu_value * statu_count)
								set(statu_name, next_value)
							elif type == 'remove':
									var next_value = prev_value - (statu_value * statu_count)
									set(statu_name, next_value)

func get_damage(atk, crit, critDMG) -> Dictionary:
	var critChance = floor(randf() * 100) / 100.0 > crit
	if critChance:
		return {
			'isCrit': true,
			'dmg': atk + atk * critDMG
		}
	else:
		return {
			'isCrit': false,
			'dmg': atk
		}

func take_damage(atkObj, multiplier = 1) -> void:

	var damageResolve = atkObj.dmg * multiplier - DEF

	var dmg_text = preload('res://PopUptext/Damage/Damage.tscn')
	var dmg_spaw = dmg_text.instantiate()
	dmg_spaw.global_position = self.position
	dmg_spaw.find_child('Dmg').text = '-' + str(damageResolve)
	self.get_parent().add_child(dmg_spaw)

	HP -= damageResolve

	if HP < 0:
		HP = 0
