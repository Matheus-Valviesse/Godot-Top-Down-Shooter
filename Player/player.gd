extends Character_base

func _ready() -> void:
	super._ready()

	var weapon_init = preload('res://Weapons_and_bullets/Weapons/weapon.tscn')
	var weapon_instantiate = weapon_init.instantiate()
	weapon = weapon_instantiate
	print(weapon)
	self.get_parent().add_child.call_deferred(weapon)

