extends KinematicBody2D

#   /// WATER PROJECTILE \\\

export var ACCELERATION = 50
export var MAX_SPEED = 1.5
export var FRICTION = 40
var velocityPlayer = Vector2.ZERO
var direction = 1

onready var player =  get_tree().get_root().get_node("Stage/Player/Player")
onready var Despawn_Timer = $Timer


func _ready():
	$Tween.interpolate_property($Camera2D, "zoom", Vector2(1, 1), Vector2(0.7,0.7), 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	timer()

func set_fireball_direction(dir):
	Engine.time_scale = 0.08
	$Tween2.interpolate_property($Light2D, "energy", 0, 1, 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween2.start()	
	direction = dir 
	if dir == 1:
		$Sprite.flip_h = true
				
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocityPlayer = velocityPlayer.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocityPlayer = velocityPlayer.move_toward(Vector2.ZERO, FRICTION * delta)
	
# warning-ignore:return_value_discarded
	move_and_collide(velocityPlayer)
	var collision = move_and_collide(velocityPlayer * delta)
	var collision_list = ["Walls2", "Walls3", "Walls" , "top", "Pizzaz"]
	if collision && collision_list.has(collision.collider.name) or collision && collision.collider.get_class() == "StaticBody2D":
		destroy(1)
	if collision && collision.collider.name == "King":
		get_tree().get_root().get_node("Stage/HUD/EnemyHUD/BossbarUI").damage_boss()
		destroy(0)
func destroy(type):
	var shake = get_tree().get_root().get_node("Stage/Camera2D/ScreenShake")
	shake.start()
	if get_tree().get_root().get_node("Stage").has_node("Player/Player"):
		player.set_state(player.REVERT)
		if type == 0:
			var boom = load("res://Assets/music/ExplosionV2.wav")
			AudioManager.play_sfx(boom, 0)
		if type == 1:
			var thud = load("res://Assets/music/thud.wav")
			AudioManager.play_sfx(thud, 0)
		if type == 2:
			pass
	else:
		pass
	Engine.time_scale = 1
	queue_free()
	
func timer():
	Despawn_Timer.start()
	
func despawn():
	if get_tree().get_root().get_node("Stage").has_node("Player/Player"):
		player.set_state(player.REVERT)
		Engine.time_scale = 1
	else:
		Engine.time_scale = 1
	queue_free()


func _on_Timer_timeout():
	print("timed out")
	despawn()
