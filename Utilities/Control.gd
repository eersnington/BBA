extends Control
#DIALOGUE BOX
signal dialogue_over

var dialogue = {
	"Intro": {
		0 : "Bob, the blue blob you see freaking out, was trying to learn a new skill at home",
		1 : "...But... he got bored, and slept off. Now, he somehow found himself inside the Hot Lands Labyrinth.",
		2 : "This place is filled with monsters called Hot Heads, and they're always pissed.",
		3 : "(Actually they're called Fire Skulls but the Dev is trying to score some humor points).",
		4 : "Anyways, Bob is very stressed of the situation he found himself in because",
		5: "...he is supposed to maintain a distance between people, and stay at home.",
		6: "You can control Bob using WASD or the Arrow Keys, and access his Power using Z key or Enter."
	},
	"Arena1":{
		0: "Bob thinks you're gonna have a bad time."
	},
	"Arena1_Alternate":{
		0: "Now that's what I call, [rainbow sat=10 val=20]Pro Gamer Move.[/rainbow]"
	},
	"Arena1_Alternate2":{
		0: "Bob thinks you've made your life easier."
	},
	"Bros" : {
		0: "Bro 2:Hey, bro.....",
		1: "Bro 1:Yeah... I see broo......",
		2: "Bro 2:That's a huge problem bro......",
		3: "Bro 1:Yeah... yeah... very huuuuuggggeeeeee.",
		4: "Bro 1: We spilled hand sanitizer, and now it's moving brooo...",
		5: "Bro 2:What?? No Idiot! That's not spilled hand sanitizer, that's the dude we all stole The Thing from.",
		6: "Bro 1: Ohhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh.",
		7: "Bro 1: Oh no.",
		8: "Bro 2: And he passed through the heavily guarded chamber as well.",
		9: "Bro 1: Oh no bro.",
		10: "Bro 2: Yeah I know, I think it's time to use it.",
		11: "Bro 2: ... The Secret Move ...",
		12: "Bro 2: ... [shake]OUR ULTIMATE MOVE[/shake] ...",
		13: "Bro 1: BROOOOOOO!!!",
		14: "Bro 1: Ohhhhhhhhhhhhhhhhhhhhhhhhhh yeahhhhhhhhhhhhhhhhhhhhhhh!!!",
		15: "Bro 1: Oh yeah."
	},
	"Death" : {
		0: "... Well...",
		1: "... Shit...",
		2: "...I literally just wan[shake rate=50]ted to take a shit.",
		3: "[shake rate=50]... a golden shit...",
		4: "[shake rate=100]...But... I guess you don't always get what you want in life.",
		5: "... So....",
		6: "[shake rate=100 level=15]...SCREW YOU BLOB!!!!!!!!!"
	},
	"KingArenaEnter" : {
		0: "Just what the hell is this!",
		1: "Fire Skull: Sire..., it was a mistake. A mishap took place while in transit, and got it damaged.",
		2: "Damage in Transit??!! ARE YOU KIDDING ME??",
		3: "*King Skull: [shake]WHAT THE HELL AM I SUPPOSED TO DO NOW?[/shake]",
		4: "*King Skull: [shake]HOW CAN I TAKE A SHIT IN PEACE??!![/shake]",
		5: "Fire Slave: Sire.., I understand how you feel, and I want to apol...",
		6: "*King Skull: [shake rate=100 level=10]SHUT UP!!! SHUT UP!!! YOU DON'T UNDERSTAND!!",
		7: "*King Skull: ... You don't understand the Pain...",
		8: "*King Skull: ... The Anguish...",
		9: "*King Skull: ... The Tribulation...",
		10: "Fire Slave: Sire... I...",
		11: "*King Skull: [shake rate=100 level=10]JUST SHUT THE HELL UP!!! SHUT UP!!! DON'T TALK OVER ME!!!",
		12: "*King Skull: The toilet seat...",
		13: "*King Skull: It has shifted 2 pixels to the right...",
		14: "*King Skull: Do you understand the severe mental stress & discomfort I feel...",
		15: "*King Skull: ... when I sit atop a broken toilet seat...",
		16: "Fire Slave: Sire... I unde...",
		17: "*King Skull: [shake rate=100 level=10]SHUT UP!!! SHUT UP!!! WHO ASKED YOU FOR YOUR OPINION!!!",
		18: "*King Skull: Ok...",
		19: "*King Skull: You know... The lack of ceiling is a good thing.",
		20: "Fire Slave: Sire... Why is that?...",
		21: "*King Skull: So I can easily throw you off without making a mess."
	},
	"KingBeforeBattle" : {
		0: "King Skull: Hmmm...",
		1: "King Skull: I sense the same energy from you.",
		2: "King Skull: The ability to command time itself.",
		3: "King Skull: Time and Tide waits for no man.",
		4: "King Skull: Luckily, I'm not a man, and I can stop time.",
		5: "King Skull: But screw tides man. That thing scares me.",
		6: "King Skull: What...? You don't care about this stuff?",
		7: "King Skull: You just want your Golden Toilet back?",
		8: "King Skull: Huh... At first you're very existence imposed great threat to My World.",
		9: "King Skull: And now you want to take MY Toilet away?!",
		10: "King Skull: [shake]I will beat the crap out of you boy!!!",
		11: "King Skull: Huh... you don't want any drama?...",
		12: "King Skull: You just want your golden toilet back?...",
		13: "King Skull: (-_-)ゞ゛...",
		14: "King Skull: [shake]SHUT UP, YOU DON'T ALWAYS GET WHAT YOU WANT IN LIFE!![/shake]"
	},
	"Toilet" : {
		0: "Even though he got his toilet back...",
		1: "... Bob feels a certain emptiness inside of him.",
		2: "As described by King Skull,",
		3: "... the imperfections of the toilet brings great anguish.",
		4: "But you should be grateful because you're doing better than someone else right?",
		5: "Isn't that what everyone says?",
		6: "Bullshit. Screw you.",
		7: "You should be ungrateful for what you have.",
		8: "You shouldn't feel satisfied with the way things are now.",
		9: "Because finding faults will give you reasons...",
		10: "... to make something a better version of itself than in foretime,",
		11: "... and make you a better version of yourself than in foretime.",
		12: "You shouldn't feel grateful for being better off than someone less fortunate.",
		13: "You should be grateful for not being less fortunate than you are now.",		
	},
	"End" : {
		0: "Bob wonders if someone else put their ass on the toilet seat."
	}
}

var dialogue_index = 0
var finished = false
var set_dict = null
var set_time = null
var set_index = null

func _ready():
	pass
	  
# warning-ignore:unused_argument
func _process(_delta):
	
	$"right-hintbox-triangle".visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		temp_analyser(set_time, dialogue[set_dict], dialogue_index)
		
func set_dialogue(time, dialogue_dict):
	temp_analyser(time, dialogue[dialogue_dict], dialogue_index)
	set_dict = dialogue_dict
	set_time = time
	
func temp_analyser(time, dict, key):
	var temp_dict = dict
	var player = get_tree().get_root().get_node("Stage/Player/Player")
	
	if key < dict.size():
		var temp_key = dict[key]
		player.set_state(player.TALK)
		load_dialogue(time, temp_key, temp_dict)
	else:
		player.set_state(player.MOVE)
		emit_signal("dialogue_over")
		get_parent().queue_free()
	dialogue_index += 1
	
func load_dialogue(time, index, dict):	
	if str(set_dict) == "Bros" && dialogue_index == 10:
		AudioManager.stop_music()
	if dialogue_index < dict.size():
		$RichTextLabel.bbcode_text = index
		$RichTextLabel.percent_visible = 0
		$Tween.interpolate_property($RichTextLabel, "percent_visible", 0, 1, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
		finished = false

func _on_Tween_tween_completed(_object, _key):
	finished = true
	$Typing.stop()

func _on_Tween_tween_started(_object, _key):
	$Typing.play()
