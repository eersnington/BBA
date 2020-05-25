extends Node2D

onready var player = null
var TEXT = preload("res://Utilities/SaveUI/SaveHealthBox.tscn")

func _ready():
	pass 

func _on_Spot_body_entered(body):
	if body.get_collision_layer_bit(0):
		player = body
		update_health()
	
func update_health():
	if player.health < player.max_health:
		player._set_health(player.max_health)
		var text = TEXT.instance()
		get_tree().get_root().get_node("Stage/HUD/PlayerHUD").add_child(text)
		var dialog = get_tree().get_root().get_node("Stage/HUD/PlayerHUD/SaveHealthBox/Control")
		dialog.set_dialogue(2, "HealthUpdated")
		player.set_state(player.TALK)

	elif player.health == player.max_health:
		var text = TEXT.instance()
		get_tree().get_root().get_node("Stage/HUD/PlayerHUD").add_child(text)
		var dialog = get_tree().get_root().get_node("Stage/HUD/PlayerHUD/SaveHealthBox/Control")
		dialog.set_dialogue(2, "HealthFull")
		player.set_state(player.TALK)
	
	else:
		pass
