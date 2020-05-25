extends Node2D

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

onready var player = get_tree().get_root().get_node("Stage/Player/Player")

onready var camera = $Camera2D

func _ready():
	
	$Camera2D/Frequency.wait_time = 1 / float(15)
	$Camera2D/Frequency.start()
	shake()
	$CanvasLayer/ColorRect.visible = false
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play("explosion")
	yield(get_tree().create_timer(1), "timeout")
	dialogue()
	
func dialogue():
	var TEXT = preload("res://Utilities/Dialogue Box.tscn")
	var text = TEXT.instance()
	get_tree().get_root().get_node("Stage/HUD/PlayerHUD").add_child(text)
	var dialog = get_tree().get_root().get_node("Stage/HUD/PlayerHUD/Dialogue Box/Control")
	dialog.connect("dialogue_over", self, "_on_dialogue_finish")
	dialog.set_dialogue(1, "Death")

func _on_dialogue_finish():
	player.set_state(player.TALK)
	yield(get_tree().create_timer(0.3), "timeout")
	$AnimationPlayer.play("light")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "light":
		$Sprite.visible = false
		$AnimatedSprite.visible = false
		$AnimationPlayer.play("light_backwards")
		
	if anim_name == "light_backwards":
		reset()
		$Camera2D/Frequency.stop()
		AudioManager.stop_music()
		yield(get_tree().create_timer(1.5),"timeout")
		get_tree().get_root().get_node("Stage/HUD/PlayerHUD/HealthBarUI").visible = true
		var remote_transform = load("res://Utilities/RemoteTransform2D.tscn").instance()
		player.add_child(remote_transform)
		player.set_state(player.MOVE)
		queue_free()
		
func shake():
	var rand = Vector2()
	rand.x = rand_range(-3, 3)
	rand.y = rand_range(-3, 3)
	
	$Camera2D/ShakeTween.interpolate_property(camera, "offset", camera.offset, rand, $Camera2D/Frequency.wait_time, TRANS, EASE)
	$Camera2D/ShakeTween.start()
	print("started")
	
func reset():
	$Camera2D/ShakeTween.interpolate_property(camera, "offset", camera.offset, Vector2(), $Camera2D/Frequency.wait_time, TRANS, EASE)
	$Camera2D/ShakeTween.start()
		
func _on_Frequency_timeout():
	shake()
	
	
	

