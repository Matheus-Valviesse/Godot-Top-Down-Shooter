extends Marker2D

func _on_animation_finished(anim_name:StringName) -> void:
	if anim_name == 'recover':
		queue_free()
