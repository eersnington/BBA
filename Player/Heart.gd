extends Area2D


func _ready():
	print("Heart Spawned" + str(global_position))

func _on_Heart_body_entered(body):
	if body.name == "Player":
		body.heal(1)
		queue_free()
