extends Node

const dum = preload("res://Assets/music/End.wav")

func _ready():
	
	yield(get_tree().create_timer(2.5), "timeout")
	$Control/RichTextLabel.visible = true
	$Control/RichTextLabel.bbcode_text = "Bob's Bizzare Adventure"
	AudioManager.play_sfx(dum)
	yield(get_tree().create_timer(6), "timeout")
	$Control/RichTextLabel.bbcode_text = "By Sreenington"
	AudioManager.play_sfx(dum)
	yield(get_tree().create_timer(6), "timeout")
	$Control/RichTextLabel.bbcode_text = "Thanks for playing"
	AudioManager.play_sfx(dum)
	
func _input(event):
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
