extends KinematicBody2D

#   /// FIRE PROJECTILE \\\
onready var velocityOrb = Vector2.ONE * 80
onready var player = get_tree().get_root().get_node("Stage/Player/Player")

	
func _physics_process(delta):
	translate(velocityOrb * delta)
	var collision = move_and_collide(velocityOrb * delta)
	if collision:
		if collision.collider == player:
			player.damage(1)
		queue_free()

