extends Node2D

var damage
var damage_multiplier

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == 'light':
		queue_free()


func _on_body_entered(body:Node2D) -> void:

	if body.has_method('get_entity') && body.get_entity() == 'player':
		body.apply_status_effect(Radiation_blessing.new())


	if body.has_method('get_entity') && body.get_entity() == 'enemy':
			body.take_damage(damage, damage_multiplier)
