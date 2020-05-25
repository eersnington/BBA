extends Control
#DEAH BOX
const DEATH_MUSIC = preload("res://Assets/music/Music/Gameover.ogg")
var dialogue = [
	"You Died",
	"Do you wish to Continue?"
	]

var dialogue_index = 0

func _ready():
	AudioManager.stop_music()
	start_dialogue()
	AudioManager.play_music(DEATH_MUSIC)
	

func _process(_delta):
	if Input.is_action_just_pressed("shoot"):
		start_dialogue()
	if $Yes.is_hovered() == true:
			$Yes.grab_focus()
	if $No.is_hovered() == true:
		$No.grab_focus()

func start_dialogue():
	if dialogue_index == 0:
		load_dialogue(1, 0)
	elif dialogue_index >= 1:
		load_dialogue(1, 1)
		$Timer.start()
		
	dialogue_index += 1

func load_dialogue(time, index):
	$RichTextLabel.bbcode_text = dialogue[index]
	$RichTextLabel.percent_visible = 0
	$Tween.interpolate_property($RichTextLabel, "percent_visible", 0, 1, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Yes_pressed():
	GameSaver.load_game()
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	

func _on_No_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Utilities/Title Screen.tscn")

func _on_Tween_tween_started(_object, _key):
	$Typing.play()

func _on_Tween_tween_completed(_object, _key):
	$Typing.stop()
	

func _on_Timer_timeout():
	$Yes.visible = true
	$No.visible = true
	$Yes.grab_focus()
