extends Control

onready var Resume_button = $MainUI/CenterContainer/VBoxContainer/Resume
onready var Exit_button = $MainUI/CenterContainer/VBoxContainer/Exit

var button_sfx = load("res://Assets/music/Buttons.wav")

func _ready():
	
	Resume_button.grab_focus()
	
func _physics_process(_delta):
	
	if Resume_button.is_hovered() == true:
		Resume_button.grab_focus()
	if Exit_button.is_hovered() == true:
		Exit_button.grab_focus()
		
func _input(event):
	if event.is_action_pressed("Pause"):
		Resume_button.grab_focus()
		get_tree().paused = not get_tree().paused
		visible = not visible



func _on_Resume_pressed():
	get_tree().paused = not get_tree().paused
	visible = not visible


func _on_Exit_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Utilities/Title Screen.tscn")
	get_tree().paused = not get_tree().paused
