extends Node

const TITLE_MUSIC = preload("res://Assets/music/Music/Balrog\'s Theme.ogg")
onready var Play_button = $MarginContainer/VBoxContainer/Play
onready var Exit_button = $MarginContainer/VBoxContainer/Exit
onready var Saves_button = $MarginContainer/VBoxContainer/Saves

var ver = "By Sreenington - Version: " + ProjectSettings.get_setting("application/config/version")
var button_sfx = load("res://Assets/music/Buttons.wav")

func _ready():
	AudioManager.stop_music()
	AudioManager.play_music(TITLE_MUSIC)
	Play_button.grab_focus()
	$Control/Version.bbcode_text = ver
	
func _physics_process(_delta):
	if Play_button.is_hovered() == true:
		Play_button.grab_focus()
	if Exit_button.is_hovered() == true:
		Exit_button.grab_focus()
	if Saves_button.is_hovered() == true:
		Saves_button.grab_focus()

func _on_Play_pressed():
	Globals.set_intro(false)
	Globals.set_gag(false)
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Stage.tscn")

func _on_Exit_pressed():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func _on_Saves_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Utilities/SaveUI/GameSaver.tscn")
