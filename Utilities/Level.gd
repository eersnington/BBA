extends Node2D

const Player: = preload("res://Player/Player.gd")
const CHECK = preload("res://Utilities/Check.tscn")
const thud = preload("res://Assets/music/thud.wav")
onready var camera = get_tree().get_root().get_node("Stage/Camera2D/CinematicMove")
var troll = false


func _ready():
	set_process(false)
	camera.connect("pan_in", self, "_on_Pan_in")

func _process(_delta):
	if get_tree().get_root().get_node("Stage/Enemies/Arena").get_child_count() == 0:
		AudioManager.stop_music()
		var shake = get_tree().get_root().get_node("Stage/Camera2D/ScreenShake")
		shake.start()
		AudioManager.play_sfx(thud, 0)	
		if troll == true:
			var list = get_tree().get_root().get_node("Stage/Level/Walls2").get_children()
			for i in list:
				i.queue_free()
			var VICTORY_MUSIC = load("res://Assets/music/Music/Victory!.wav")
			AudioManager.play_music(VICTORY_MUSIC)
			queue_free()
		else:
			var VICTORY_MUSIC = load("res://Assets/music/Music/Victory!.wav")
			AudioManager.play_sfx(VICTORY_MUSIC)
			get_tree().get_root().get_node("Stage/Level/Troll").disconnect("body_entered", self, "_on_Troll_body_entered")
			queue_free()
			
func _on_Arena1_body_entered(body):
	if body is Player:
		AudioManager.stop_music()
		body.set_state(body.TALK)
		wall_slam(696, 512, 696, 528)
		yield(get_tree().create_timer(0.9), "timeout")
		camera.start(0.3, 130, 0)
		self.disconnect("body_entered", self, "_on_Arena1_body_entered")
		
func frickening(sig, key):
	var TEXT = preload("res://Utilities/Dialogue Box.tscn")
	var text = TEXT.instance()
	get_tree().get_root().get_node("Stage/HUD/PlayerHUD").add_child(text)
	var dialog = get_tree().get_root().get_node("Stage/HUD/PlayerHUD/Dialogue Box/Control")
# warning-ignore:return_value_discarded
	dialog.connect("dialogue_over", self, sig)
	dialog.set_dialogue(1.5, key)

func _Arena1():
	var player = get_tree().get_root().get_node("Stage/Player/Player")
	player.set_state(player.TALK)
	camera._reset()
	var BATTLE_MUSIC = load("res://Assets/music/Music/Gravity.ogg")
	AudioManager.play_music(BATTLE_MUSIC)
	yield(get_tree().create_timer(2.9), "timeout")
	var room1 = get_tree().get_root().get_node("Stage/Enemies/Arena").get_children()
	for i in room1:
		i.set("Search", true)
		i.set("Shoot", true)
	player.set_state(player.MOVE)
	set_process(true)

func _Arena1_Alternate():
	var player = get_tree().get_root().get_node("Stage/Player/Player")
	player.set_state(player.TALK)
	camera._reset()
	yield(get_tree().create_timer(2.5), "timeout")
	player.set_state(player.MOVE)
	set_process(true)
		
func _on_Pan_in():
	check_enemies()

func wall_slam(x1, y1, x2, y2):
	var pillar1 = load("res://Utilities/Pillar.tscn").instance()
	var pillar2 = load("res://Utilities/Pillar.tscn").instance()
	get_tree().get_root().get_node("Stage/Level/Walls").call_deferred("add_child", pillar1)
	pillar1.set_global_position(Vector2(x1, y1))
	AudioManager.play_sfx(thud, 0)
	var shake = get_tree().get_root().get_node("Stage/Camera2D/ScreenShake")
	shake.start()
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().get_root().get_node("Stage/Level/Walls").call_deferred("add_child", pillar2)
	pillar2.set_global_position(Vector2(x2, y2))
	shake.start()
	AudioManager.play_sfx(thud, 0)
	
func check_enemies():
	var area = CHECK.instance()
	add_child(area)   
	yield(get_tree().create_timer(0.4), "timeout")
	var body_list = area.get_overlapping_bodies()
	if body_list.size() == 0:
		frickening("_Arena1_Alternate", "Arena1_Alternate")
	elif body_list.size() < 8:
		frickening("_Arena1", "Arena1_Alternate2")
	else: 
		frickening("_Arena1", "Arena1")
		

func _on_Area2D_body_entered(body):
	if body is Player:
		wall_slam(1032, 512, 1032, 528)
		get_tree().get_root().get_node("Stage/Level/Area2D").disconnect("body_entered", self, "_on_Area2D_body_entered")


func _on_Troll_body_entered(body):
	if body is Player:
		var pillar1 = load("res://Utilities/Pillar.tscn").instance()
		var pillar2 = load("res://Utilities/Pillar.tscn").instance()
		get_tree().get_root().get_node("Stage/Level/Walls2").call_deferred("add_child", pillar1)
		pillar1.set_global_position(Vector2(1032, 512))
		get_tree().get_root().get_node("Stage/Level/Walls2").call_deferred("add_child", pillar2)
		pillar2.set_global_position(Vector2(1032, 528))
		AudioManager.play_sfx(thud, 0)
		var shake = get_tree().get_root().get_node("Stage/Camera2D/ScreenShake")
		shake.start()
		troll = true
		get_tree().get_root().get_node("Stage/Level/Troll").disconnect("body_entered", self, "_on_Troll_body_entered")
		
