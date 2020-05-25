extends Area2D

var Player: = preload("res://Player/Player.gd")

onready var watchskull = get_tree().get_root().get_node("Stage/Enemies/WatchSkull2")

func _ready():
	watchskull.connect("anim_over", self, "_on_Turn_animation_over")
	
func frickening(sig, key):
	print("called frick")
	var TEXT = preload("res://Utilities/Dialogue Box.tscn")
	var text = TEXT.instance()
	get_tree().get_root().get_node("Stage/HUD/PlayerHUD").add_child(text)
	var dialog = get_tree().get_root().get_node("Stage/HUD/PlayerHUD/Dialogue Box/Control")
# warning-ignore:return_value_discarded
	dialog.connect("dialogue_over", self, sig)
	dialog.set_dialogue(1.5, key)


func _on_Gag_body_entered(body):
	if body is Player:
		body.set_state(body.TALK)
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().get_root().get_node("Stage/Enemies/WatchSkull2/AnimationPlayer").play("Gag1_Bro2")
		get_tree().get_root().get_node("Stage/Enemies/WatchSkull1/AnimationPlayer").play("Gag1_Bro1")
		self.disconnect("body_entered", self, "_on_Gag_body_entered")
			
func _on_Turn_animation_over():
	frickening("_animation_Over", "Bros")
	var GAG = load("res://Assets/music/Music/Jenka 1.ogg")
	AudioManager.play_music(GAG)
	
func _animation_Over():
	yield(get_tree().create_timer(1), "timeout")
	get_tree().get_root().get_node("Stage/Enemies/WatchSkull2").blow_up()
	get_tree().get_root().get_node("Stage/Enemies/WatchSkull1").blow_up()
	var boom = load("res://Assets/music/ExplosionV2.wav")
	AudioManager.play_sfx(boom, 0)
	Globals.gag = true

