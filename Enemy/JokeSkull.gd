extends KinematicBody2D

var yeeticus = false

func _ready():
	set_physics_process(false)
	
func yeet():
	set_physics_process(true)
	var ahh = load("res://Assets/music/Ow.wav")
	AudioManager.play_sfx(ahh)
	$AnimationPlayer.play("Yeet_Spin")
	$Duration.start()

func _physics_process(delta):
	yeeticus = true
	translate(Vector2(1, -1) * delta * 150)	

func _on_Duration_timeout():
	queue_free()
