extends CharacterBody2D
class_name Character_base

var HP 					: float = 10
var HPMax 			: float = 1000

var MP					: float = 300
var MPMax 			: float = 300

var ATK 				: float = 300
var ATKMax 			: float = 0

var DEF 				: float = 300
var DEFMax 			: float = 0

var SPEED 			: float = 180
var SPEEDMax 		: float = 0

var CRIT        : float = 0.15
var CRITMax			: float = 0.50

var CRITDmg     : float = 0.15
var CRITDmgMax	: float = 0.50

var status_effects : Array = []
var status_bonus:  Array = []
var status_item: Array = []

var type_entity = 'player'
@onready var arm = $Arm
@onready var hand = $Arm/Hand

var weapon 

var self_hud

func _ready() -> void:

	var player_hud = preload('res://Hud/Hud.tscn')
	var hud_istantiate = player_hud.instantiate()
	self_hud = hud_istantiate	
	self.get_parent().add_child.call_deferred(self_hud)
	hud_edit()

func _input(event: InputEvent) -> void:

	if event is InputEventKey and event.is_pressed():
			if event.keycode == KEY_1:
				
				var skill = Divine_protection.new()
				skill._call_skill(self)
				hud_edit()
				
			if event.keycode == KEY_2:
				apply_status_effect(Radiation_blessing.new())

	if event is InputEventMouse and event.is_pressed():
		if weapon && weapon.stat == 'idle':
			weapon.shoot()

	hud_edit()

func get_input() -> void:

	var input_direction = Input.get_vector("left","right","up","down")
	velocity = input_direction * SPEED

func _physics_process(delta: float) -> void:

	print()

	get_input()
	move_and_slide()

	hand_movement()

	for i in range(status_effects.size()):

		var effect = status_effects[i]
		effect.duration -= delta
		
		if(effect.has_method('apply_in_time')):

			effect.apply_in_time(delta, self)

		if effect.duration < 0:

			apply_bonus(status_effects[i].get_effect_name(),'remove')
			effect.remove(self)
			status_effects.remove_at(i)
			break
	
func hand_movement() -> void:
	arm.look_at(get_global_mouse_position())

	if weapon !=  null:
		weapon.global_position = hand.global_position
		weapon.look_at(get_global_mouse_position())
		
func apply_status_effect(effect) -> void:

	var effect_exist : bool = false

	for exist in range(status_effects.size()):

		effect_exist =  status_effects[exist].get_effect_name() == effect.get_effect_name()

		if effect_exist:
			apply_bonus(status_effects[exist].get_effect_name(),'remove')
			for i in range(status_effects.size()):
				if status_effects[i].get_effect_name() == effect.get_effect_name():
					status_effects[i].duration = effect.duration
			
			for i in range(status_bonus.size()):
				if status_bonus[i].name == effect.get_effect_name() && status_bonus[i].values.COUNT < effect.count_max:
					status_bonus[i].values.COUNT += 1
			apply_bonus(status_effects[exist].get_effect_name(),'apply')
			return

	status_effects.append(effect)
	effect.apply(self)
	apply_bonus(effect.get_effect_name(),'apply')

func apply_bonus(statuName: String , type: String) -> void:

	if(type):

		for i in range(status_bonus.size()):

			if status_bonus[i].name == statuName:

				for value in range(status_bonus[i].values.size()):

					var statu_name = status_bonus[i].values.keys()[value]
					var statu_value = status_bonus[i].values.values()[value]
					var statu_count = status_bonus[i].values.COUNT
					var prev_value = get(statu_name)

					if(prev_value):
						
						if(type == 'apply'):
							var next_value = prev_value + (statu_value * statu_count)
							set(statu_name, next_value )
						if(type == 'remove'):
							var next_value = prev_value - (statu_value * statu_count)
							set(statu_name, next_value )
				
func hud_edit() -> void:
	self_hud._hp_change(self)
	self_hud._mp_change(self)