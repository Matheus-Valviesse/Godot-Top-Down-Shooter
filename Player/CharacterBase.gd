extends CharacterBody2D
class_name Character_base

var HP: float = 300
var HP_Bonus: float = 0
var HPMax: float = 1000

var MP: float = 300
var MP_Bonus: float = 0
var MPMax: float = 300

var ATK: float = 500
var ATK_Bonus: float = 0

var DEF: float = 300
var DEF_Bonus: float = 0

var SPEED: float = 180
var SPEED_Bonus: float = 0

var CRIT: float = 0.15
var CRIT_Bonus: float = 0

var CRITDmg: float = 0.50
var CRITDmg_Bonus: float = 0


var status_effects: Array = []
var passives: Array = []

var status_bonus: Array = []
var status_item: Array = []

var type_entity: String = 'player'

@onready var arm = $Arm
@onready var hand = $Arm/Hand

var weapon

var self_hud: CanvasLayer

var weapon_reload: bool

func _ready() -> void:

	# iniciação da hud do player
	var player_hud = preload('res://Hud/Hud.tscn')
	var hud_istantiate = player_hud.instantiate()
	self_hud = hud_istantiate
	self.get_parent().add_child.call_deferred(self_hud)
	hud_edit()

func _input(event: InputEvent) -> void:

	if event is InputEventKey and event.is_pressed():
			if event.keycode == KEY_1:

				var skill = Divine_protection.new()
				skill._call_skill(self, get_damage(ATK, CRIT, CRITDmg))
				hud_edit()

			if event.keycode == KEY_2:
				apply_status_effect(Radiation_blessing.new())

			if event.keycode == KEY_3:
				take_damage({
			'isCrit': false,
			'dmg': 600
			})

			if event.keycode == KEY_4:
				apply_status_effect(Speed.new())

	if event is InputEventMouse and event.is_pressed():
		if weapon && weapon.stat == 'idle':
			weapon.shoot(get_damage(ATK, CRIT, CRITDmg), self)

	hud_edit()

func get_input() -> void:

	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * (SPEED + SPEED_Bonus)

func _physics_process(delta: float) -> void:

	get_input()
	move_and_slide()
	print(velocity)
	hand_movement()

	for i in range(status_effects.size()):

		var effect = status_effects[i]
		effect.duration -= delta

		if (effect.has_method('apply_in_time')):

			effect.apply_in_time(delta, self)

		if effect.duration < 0:

			apply_bonus(status_effects[i].get_effect_name(), 'remove')
			effect.remove(self)
			status_effects.remove_at(i)
			break

func hand_movement() -> void:
	arm.look_at(get_global_mouse_position())

	if weapon != null:
		weapon.global_position = hand.global_position
		weapon.look_at(get_global_mouse_position())

# Aplicas os status e verifica se vai ser resetado
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
				if status_bonus[i].name == effect.get_effect_name() && status_bonus[i].values.COUNT < effect.count_max:
					status_bonus[i].values.COUNT += 1

			apply_bonus(status_effects[exist].get_effect_name(), 'apply')
			return

	status_effects.append(effect)
	effect.apply(self)
	apply_bonus(effect.get_effect_name(), 'apply')

# Aplica os bonus a cada categoria
func apply_bonus(statuName: String, type: String) -> void:

	if (type):

		for i in range(status_bonus.size()):

			if status_bonus[i].name == statuName:

				for value in range(status_bonus[i].values.size()):

					var statu_name = status_bonus[i].values.keys()[value]
					var statu_value = status_bonus[i].values.values()[value]
					var statu_count = status_bonus[i].values.COUNT
					var prev_value = get(statu_name)

					if (prev_value):
						print(statu_name)
						if (type == 'apply'):
							var next_value = prev_value + (get_value(statu_value) * statu_count)
							set(statu_name + "_Bonus",next_value)

						if (type == 'remove'):
							var next_value = prev_value - (get_value(statu_value) * statu_count)
							set(statu_name + "_Bonus",next_value)

# Controle da hud do player
func hud_edit() -> void:
	self_hud._hp_change(self)
	self_hud._mp_change(self)

func get_damage(atk, crit, critDMG) -> Dictionary:

	var critChance = randf() > crit

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
	dmg_spaw.find_child('Dmg').text = '-' + "%.2f" % damageResolve
	self.get_parent().add_child(dmg_spaw)

	HP -= damageResolve

	if HP < 0:
		HP = 0

	hud_edit()

func get_entity() -> String:
	return type_entity

func get_value(value):
	if value is Callable:
		return value.call() # Se for uma função, chamamos
	return value # Caso contrário, retornamos o valor diretamente