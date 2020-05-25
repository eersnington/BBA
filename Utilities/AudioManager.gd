extends Node

onready var tween_out = $Music/Tween
onready var transition_duration = 1
onready var transition_type = Tween.TRANS_LINEAR

var dic = {}

func _process(_delta):
	if Engine.time_scale != 1:
		fade_in()
	else:
		fade_out()

func play_sfx(audio_clip : AudioStream, priority : int = 0):
	for child in $SFX.get_children():
		if child.playing == false:
			child.stream = audio_clip
			child.play()
			dic[child.name] = priority
			break
		if child.get_index() == $SFX.get_child_count() - 1: #if current child is last one
			var priority_player = check_priority(dic, priority)
			if priority_player !=null:
				$SFX.get_node(priority_player).stream = audio_clip
				$SFX.get_node(priority_player).play()
				dic[priority_player] =priority
	pass

func check_priority(_dic : Dictionary, _priority):
	var prio_list = []
	
	for key in _dic:
		if _priority > _dic[key]:
			prio_list.append(key)
			
	var last_prio = null
	for key in prio_list:
		if last_prio == null:
			last_prio = key
			continue
		if _dic[key] < _dic[last_prio]:
			last_prio = key
	return last_prio
	
func play_music(music_clip : AudioStream):
	$Music/MusicPlayer.stream = music_clip
	$Music/MusicPlayer.play()
	pass
	
func fade_out():
	tween_out.interpolate_property($Music/MusicPlayer, "volume_db", -5, -35, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()

func fade_in():
	tween_out.interpolate_property($Music/MusicPlayer, "volume_db", -35, -5, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()
	
func stop_music():
	$Music/MusicPlayer.stop()

