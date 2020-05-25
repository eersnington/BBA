extends Node2D

const Player: = preload("res://Player/Player.gd")
const CHECK = preload("res://Utilities/Check.tscn")
const thud = preload("res://Assets/music/thud.wav")
onready var camera = get_tree().get_root().get_node("Stage/Camera2D/CinematicMove")
onready var player = get_tree().get_root().get_node("Stage/Player/Player")
onready var king = get_tree().get_root().get_node("Stage/Enemies/King/King")
onready var joke_skull = get_tree().get_root().get_node("Stage/Enemies/King/Jokeskull")

var pan_finished = false

func _ready():
	camera.connect("pan_in", self, "_on_Pan_in")

func _process(_delta):
	if !get_tree().get_root().has_node("Stage/Enemies/King/King"):
		var RUMBLE = load("res://Assets/music/Rumble.ogg")
		AudioManager.play_music(RUMBLE)
# warning-ignore:return_value_discarded
		get_tree().get_root().get_node("Stage/Levels/Toilet/Area2D").connect("body_entered", self, "_on_Toilet_body_entered")
		set_process(false)

func wall_slam(x1, x2, x3, y):
	var shake = get_tree().get_root().get_node("Stage/Camera2D/ScreenShake")
	var pillar1 = load("res://Utilities/PillarV2.tscn").instance()
	var pillar2 = load("res://Utilities/PillarV2.tscn").instance()
	var pillar3 = load("res://Utilities/PillarV2.tscn").instance()
	get_tree().get_root().get_node("Stage/Levels/Walls").call_deferred("add_child", pillar1)
	pillar1.set_global_position(Vector2(x1, y))
	AudioManager.play_sfx(thud, 0)
	shake.start()
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().get_root().get_node("Stage/Levels/Walls").call_deferred("add_child", pillar2)
	pillar2.set_global_position(Vector2(x2, y))
	shake.start()
	AudioManager.play_sfx(thud, 0)
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().get_root().get_node("Stage/Levels/Walls").call_deferred("add_child", pillar3)
	pillar3.set_global_position(Vector2(x3, y))
	shake.start()
	AudioManager.play_sfx(thud, 0)


func _on_Enter_body_entered(body):
	if body is Player:
		yield(get_tree().create_timer(0.2), "timeout")
		player.set_state(player.TALK)
		wall_slam(152, 168, 184, -120)
		yield(get_tree().create_timer(1), "timeout")
		camera.start(0.05, 0, -280)
		yield(get_tree().create_timer(1), "timeout")
		var GAG = load("res://Assets/music/Music/Jenka 1.ogg")
		AudioManager.play_music(GAG)
		frickening("_on_dialogue_finish", "KingArenaEnter")
		get_tree().get_root().get_node("Stage/Levels/Enter").disconnect("body_entered", self, "_on_Enter_body_entered")

func frickening(sig, key):
	var TEXT = preload("res://Utilities/Dialogue Box.tscn")
	var text = TEXT.instance()
	get_tree().get_root().get_node("Stage/HUD/PlayerHUD").add_child(text)
	var dialog = get_tree().get_root().get_node("Stage/HUD/PlayerHUD/Dialogue Box/Control")
# warning-ignore:return_value_discarded
	dialog.connect("dialogue_over", self, sig)
	dialog.set_dialogue(1.5, key)		

func _on_Pan_in():
	pan_finished = true

func _on_dialogue_finish():
	var shake = get_tree().get_root().get_node("Stage/Camera2D/ScreenShake")
	if pan_finished == true:
		yield(get_tree().create_timer(0.5), "timeout")
		joke_skull.yeet()
		yield(get_tree().create_timer(2), "timeout")
		camera.stop()
		yield(get_tree().create_timer(2.5), "timeout")
		AudioManager.stop_music()
		king.play_talk()
		shake.start()
		yield(get_tree().create_timer(1), "timeout")
		frickening("battle_start", "KingBeforeBattle")
		
	else:
		camera.complete_stop()
		yield(get_tree().create_timer(0.5), "timeout")
		AudioManager.stop_music()
		king.play_talk()
		shake.start()
		yield(get_tree().create_timer(1), "timeout")
		frickening("battle_start", "KingBeforeBattle")
		yield(get_tree().create_timer(1.25), "timeout")
		joke_skull.yeet()
		
func battle_start():
	var BATTLE_THEME = load("res://Assets/music/Music/Last Battle.ogg")
	AudioManager.play_music(BATTLE_THEME)
	king.battle_begin()
	player.set_state(player.MOVE)
	player.shoot = true
	
func _on_Toilet_body_entered(body):
	if body is Player:
		player.shoot = false
		frickening("final_message", "Toilet")
		
func final_message():
	player.set_state(player.TALK)
	yield(get_tree().create_timer(5), "timeout")
	frickening("transition", "End")
	
		
		
func transition():
	player.set_state(player.TALK)
	get_tree().get_root().get_node("Stage/HUD/Transition/AnimationPlayer").play("Transition")
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Transition":
		get_tree().change_scene("res://End Credits.tscn")
