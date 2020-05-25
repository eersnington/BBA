extends Area2D

var player = null

func can_see_player():
	return player != null
	
func _on_PlayerDetection_body_entered(body):
	if body.get_collision_layer_bit(0):
		player = body

func _on_PlayerDetection_body_exited(body):
	if body.get_collision_layer_bit(0):
		player = null
	


