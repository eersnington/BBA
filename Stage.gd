extends Node

const BG_MUSIC = preload("res://Assets/music/Music/Jenka 2.ogg")
const thud = preload("res://Assets/music/thudV2.wav")

var GAMER = preload("res://Player/Player.tscn")
var gamer = GAMER.instance()

func _ready():
	AudioManager.stop_music()
	Engine.time_scale = 1
	AudioManager.play_sfx(thud)
	if Globals.get_intro() == false:
		get_node("Player").add_child(gamer)
		gamer.set_state(gamer.TALK)
		yield(get_tree().create_timer(2), "timeout")	
		var TEXT = preload("res://Utilities/Dialogue Box.tscn")
		var text = TEXT.instance()
		get_node("HUD/PlayerHUD").add_child(text)
		var dialog = get_node("HUD/PlayerHUD/Dialogue Box/Control")
		dialog.set_dialogue(4, "Intro")
		dialog.connect("dialogue_over", self, "music")
	else:
		GameSaver.load_game()
		print("loaded game")
		if Globals.gag  != true:
			AudioManager.play_music(BG_MUSIC)

	if Globals.gag  == true:
		get_node("Level/Gag").disconnect("body_entered", get_node("Level/Gag"), "_on_Gag_body_entered")
		get_node("Enemies/WatchSkull2").call_deferred("queue_free")
		get_node("Enemies/WatchSkull1").call_deferred("queue_free")



func _input(event):
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen



func _on_ToKing_body_entered(body):
	if body.name == "Player":
		var suspense = load("res://Assets/music/ToKing.wav")
		AudioManager.play_sfx(suspense)
		gamer.set_state(gamer.TALK)
		yield(get_tree().create_timer(0.5), "timeout")
		get_node("HUD/PlayerHUD/HealthBarUI").visible = false
		get_node("HUD/SceneChange/AnimationPlayer").play("fade")
		yield(get_tree().create_timer(8.5), "timeout")
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://KingsArena.tscn")
		
func music():
	AudioManager.play_music(BG_MUSIC)
		
