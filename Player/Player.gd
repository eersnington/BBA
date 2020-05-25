extends KinematicBody2D

signal health_updated(health)
signal damage_received
signal killed

export var ACCELERATION = 900
export var MAX_SPEED = 130
export var FRICTION = 900
var velocityPlayer = Vector2.ZERO
var invulnerability = false
var shoot = true

export (float) var max_health = 3
onready var health = max_health setget _set_health, _get_health

const WATERBALL = preload("res://Player/Waterball.tscn")

onready var invulnerabilityTimer = $InvulnerabilityTimer
onready var animationPlayer = $AnimationPlayer
onready var invincibilityLabel = get_tree().get_root().get_node("Stage/HUD/PlayerHUD/HealthBarUI/Invincibility")

enum {
	MOVE
	STOPPED
	REVERT
	DEATH
	TALK
}
export var state = MOVE setget set_state

func _ready():
# warning-ignore:return_value_discarded
	self.connect("health_updated", get_tree().get_root().get_node("Stage/HUD/PlayerHUD/HealthBarUI") , "_on_health_updated")

func _physics_process(delta):
	match state:
		MOVE:
			move(delta)
		STOPPED:
			time_stopped()
		REVERT:
			revert()
		DEATH:
			death_state()
		TALK:
			talk_state()
	
	if invulnerability == true:
		invincibilityLabel.visible = true
		invincibilityLabel.bbcode_text = "Invincibility " + str(stepify(invulnerabilityTimer.time_left, 0.01))
	else:
		invincibilityLabel.visible = false
		
			
	
func move(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if Input.is_action_just_pressed("shoot") && shoot == true:
		state = STOPPED
		var Wprojectile = WATERBALL.instance()
		get_parent().add_child(Wprojectile)
		Wprojectile.set_position($Position2D.get_global_position())
		if sign($Position2D.position.x) == 1:
			animationPlayer.play("fire_right")
			Wprojectile.set_fireball_direction(1)
		else:
			animationPlayer.play("fire_left")
			Wprojectile.set_fireball_direction(-1)
			
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			if sign($Position2D.position.x) == -1:
				$Position2D.position *= -1
			animationPlayer.play("right")
		else:
			if sign($Position2D.position.x) == +1:
				$Position2D.position *= -1
			animationPlayer.play("left")
		
		velocityPlayer = velocityPlayer.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		velocityPlayer = velocityPlayer.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocityPlayer = move_and_slide(velocityPlayer)	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			pass
			

func time_stopped():
	velocityPlayer = Vector2.ZERO
	
func revert():
	if velocityPlayer.x <=0:
		animationPlayer.play("left")
	else:
		animationPlayer.play("right")
	state = MOVE

func set_state(new_state):
	state = new_state

func damage(amount):
	if invulnerabilityTimer.is_stopped():
		invulnerabilityTimer.start()
		_set_health(health - amount)
		get_tree().get_root().get_node("Stage/HUD/PlayerHUD/ScreenShake").start()
		animationPlayer.play("damaged")
		invulnerability = true
		var hurt = load("res://Assets/music/hurt.wav")
		AudioManager.play_sfx(hurt)
		emit_signal("damage_received")
		
func talk_state():
	velocityPlayer = Vector2.ZERO
	
func death_state():
	velocityPlayer = Vector2.ZERO
	if get_tree().get_root().get_node("Stage/Player").has_node("Waterball"):
		get_tree().get_root().get_node("Stage/Player/Waterball").destroy()
	var MAIN = load("res://Utilities/DeathUI/Death_Box.tscn")
	var main = MAIN.instance()
	get_tree().get_root().get_node("Stage/HUD").add_child(main)
	queue_free()

func kill():
	state = DEATH
	
func _get_health():
	return health
	
func _set_health(value):
	var prev_health = health
	health = clamp( value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
	if health == 0:
		kill()
		emit_signal("killed")

func _on_InvulnerabilityTimer_timeout():
	animationPlayer.play("rest")
	invulnerability = false
	
	
func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : round(position.x),
		"pos_y" : (round(position.y) +11),
		"health" : health,
		"introduction" : true,
		"gag" : Globals.gag
	}
	return save_dict
