extends Control
#SAVE BOX
var dialogue = {
	"HealthFull":{
		0: "Your health is already full. Would you like to save?",
	},
	"HealthUpdated":{
		0: "You're now completely healed. Would you like to save?",
	}
}

var dialogue_index = 0
var set_dict = null
var set_time = null
var set_index = null

func _ready():
	$No.grab_focus()
	  
func _process(_delta):
	
	if Input.is_action_just_pressed("ui_accept"):
		temp_analyser(set_time, dialogue[set_dict], dialogue_index)
		
func set_dialogue(time, dialogue_dict):
	temp_analyser(time, dialogue[dialogue_dict], dialogue_index)
	set_dict = dialogue_dict
	set_time = time
	
func temp_analyser(time, dict, key):
	var player = get_tree().get_root().get_node("Stage/Player/Player")
	var temp_dict = dict
	
	if key < dict.size():
		var temp_key = dict[key]
		player.set_state(player.TALK)
		load_dialogue(time, temp_key, temp_dict)
	
	dialogue_index += 1
	
func load_dialogue(time, index, dict):
	if dialogue_index < dict.size():
		$RichTextLabel.bbcode_text = index
		$RichTextLabel.percent_visible = 0
		$Tween.interpolate_property($RichTextLabel, "percent_visible", 0, 1, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()

	
func _on_Tween_tween_completed(_object, _key):
	$Typing.stop()
	$Yes.visible = true
	$No.visible = true
	$No.grab_focus()

func _on_Tween_tween_started(_object, _key):
	$Typing.play()


func _on_No_pressed():
	var player = get_tree().get_root().get_node("Stage/Player/Player")
	player.set_state(player.MOVE)
	get_parent().queue_free()


func _on_Yes_pressed():
	var player = get_tree().get_root().get_node("Stage/Player/Player")
	player.set_state(player.MOVE)
	GameSaver.save_game()
	get_parent().queue_free()
	
