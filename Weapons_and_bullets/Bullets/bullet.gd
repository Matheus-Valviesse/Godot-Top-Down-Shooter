extends Area2D

var velocity = Vector2.RIGHT
var speed = 220
var damage 
var target

@onready var animation = $	Bullet_animation

func _physics_process(delta: float) -> void:
	position += velocity * delta

func bullet_explosion():
	animation.play('destroy')
	velocity = Vector2.ZERO
	

func _on_body_entered(body: Node2D) -> void:
	if body.has_method('get_entity') && body.get_entity() != target.get_entity():
		print(damage)
		body.take_damage(damage)
		bullet_explosion()

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'destroy':
		queue_free()
