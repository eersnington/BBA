extends Control

var save_game = File.new()

func _ready():
	$Back.grab_focus()
	if save_game.file_exists("user://saves/save.json"):
		load_option()

func _physics_process(_delta):
	if $Back.is_hovered() == true:
		$Back.grab_focus()
	if $OptionButton.is_hovered() == true:
		$OptionButton.grab_focus()
		
func load_option():
	$OptionButton.visible = true

func _on_Back_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Utilities/Title Screen.tscn")


func _on_OptionButton_pressed():
	Globals.set_intro(true)
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Stage.tscn")
