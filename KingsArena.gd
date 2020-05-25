extends Node

const thud = preload("res://Assets/music/thudV2.wav")

func _ready():
	AudioManager.stop_music()
	get_node("HUD/EnemyHUD/BossbarUI").visible = false
	AudioManager.play_sfx(thud)
	get_node("Player/Player").shoot = false


func _input(event):
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
