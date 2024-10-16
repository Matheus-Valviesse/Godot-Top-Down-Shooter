extends Node2D

var ammo_current = 10
var ammo_max = 10

var stat = 'idle'

var Bullet = preload('res://Weapons_and_bullets/Bullets/bullet.tscn')

@onready var animation = $Weapon_animation
@onready var spaner = $Bullet_spawn

var damage 
var target
func shoot(damage_apply, target_creator):
	if ammo_current > 0 && stat == 'idle':
		animation.play('shoot')
		damage = damage_apply
		target = target_creator
		
func spwan_weapon():
	var bullet_spawned = Bullet.instantiate()
	self.get_parent().add_child(bullet_spawned)
	bullet_spawned.rotation = global_rotation
	bullet_spawned.position = spaner.global_position
	bullet_spawned.velocity = Vector2(bullet_spawned.speed,0).rotated(global_rotation)
	bullet_spawned.damage = damage
	bullet_spawned.target = target
	ammo_current -= 1

func _on_animation_finished(anim_name:StringName) -> void:
	if anim_name == 'shoot':
		stat = 'idle'
		animation.play('idle')
