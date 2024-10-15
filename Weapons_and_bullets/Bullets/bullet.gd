extends Area2D

var velocity = Vector2.RIGHT
var speed = 120

@onready var animation = $	Bullet_animation

func _physics_process(delta: float) -> void:
	position += velocity * delta

func bullet_explosion():
	animation.play('destroy')
	velocity = Vector2.ZERO
	

func _on_body_entered(body: Node2D) -> void:
	if body.name == 'Enemy':
		bullet_explosion()

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'destroy':
		queue_free()
