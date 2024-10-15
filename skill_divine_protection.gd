extends Node2D

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == 'light':
		queue_free()


func _on_body_entered(body:Node2D) -> void:
	if 'type_entity' in body:
		if body.type_entity =='player':
			body.apply_status_effect(Radiation_blessing.new())