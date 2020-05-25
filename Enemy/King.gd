extends KinematicBody2D

const MINIONS = preload("res://Enemy/Fire_Skull.tscn")
const LASER = preload("res://Enemy/Firelaser.tscn")
const Skulls = preload("res://Enemy/Fire_Skull.gd")
const DEATH_EFFECT = preload("res://Enemy/KingExplosionEffect.tscn")
const KSkull = preload("res://Assets/music/KingSkull.wav")

onready var enemies_list = get_parent().get_node("Minions")
onready var player = get_tree().get_root().get_node("Stage/Player/Player")
onready var boss_bar = get_tree().get_root().get_node("Stage/HUD/EnemyHUD/BossbarUI")
onready var shake = get_tree().get_root().get_node("Stage/Camera2D/ScreenShake")

var teleport_ok = false
var damaged = false
var spawned = false
var enemy_pos = Vector2.ZERO
var killed = false
var shoot = false

export var ACCELERATION = 500
export var MAX_SPEED = 1.25

var fire_direction = Vector2.ZERO
var velocityEnemy = Vector2.ZERO
var move_teleport = Vector2.ZERO

enum {
	IDLE
	TALK
	MOVE
	TELEPORT
	SPAWN
	DEATH
}

var state = TALK setget set_state
var previous_state = null


func _ready():
# warning-ignore:return_value_discarded
	boss_bar.connect("damaged", self, "_on_Damage_received")
# warning-ignore:return_value_discarded
	get_tree().get_root().get_node("Stage/Player/Player").connect("killed", self , "player_killed")

func _process(_delta):
	pass
	if spawned == true && state != DEATH:
		if enemies_list.get_child_count() == 0:
			set_state(TELEPORT)
			spawned = false
	if get_tree().get_root().get_node("Stage/Player").has_node("Waterball")  && state != DEATH:
		set_state(MOVE)
		
func _physics_process(delta):

	match state:
		IDLE:
			idle_state()
		TALK:
			talk_state()
		MOVE:
			move_state(delta)
		TELEPORT:
			teleport_state()
		SPAWN:
			spawn_state()
		DEATH:
			death_state()

func set_state(new_state):
	previous_state = state
	state = new_state
	
func idle_state():
	$AnimationPlayer.play("Normal")
	pass

func talk_state():
	$AnimationPlayer.play("Open_mouth")
	
# warning-ignore:unused_argument
func move_state(delta):
	pass
	var positions = get_parent().get_node("Positions").get_children()
	var first_pos = positions.front()
	var direction = null
	if !get_tree().get_root().get_node("Stage/Player").has_node("Waterball") && spawned != true:
		set_state(TELEPORT)
		return
	elif !get_tree().get_root().get_node("Stage/Player").has_node("Waterball") && spawned == true:
		set_state(IDLE)
		global_position = move_teleport
		return
	var player_pos = get_tree().get_root().get_node("Stage/Player/Waterball").global_position
	for pos in positions:
		if pos.global_position.distance_to(player_pos) > first_pos.global_position.distance_to(player_pos):
			direction = (pos.global_position - global_position).normalized()
			move_teleport = pos.global_position
			
			

	velocityEnemy = velocityEnemy.linear_interpolate(direction * MAX_SPEED, ACCELERATION * delta)
# warning-ignore:return_value_discarded
	move_and_collide(velocityEnemy)

func spawn_state():
	pass
	if spawned != false:
		return
	var enemy_type = [true, false]

	for i in range(0, 6):
		var skulls = MINIONS.instance()
		var offset = Vector2(i, i)
		skulls.set_name("Minions_" +str(i))
		var type = randi() % enemy_type.size()
		enemies_list.add_child(skulls)
		skulls.set_global_position(enemy_pos.global_position + offset)
		skulls.set("Shoot", enemy_type[type])
		continue
	
	spawned = true
	$AnimationPlayer.play("Normal")
	set_state(IDLE)
	
	
func teleport_state():
	pass
	if teleport_ok != true:
		return
	if killed != false:
		return

	var positions = get_parent().get_node("Positions").get_children()
	var player_pos = player.global_position
	var nearest_pos = positions.front()
	var old_pos = Vector2()

	for pos in positions:
		if damaged != true:
			#teleports towards player
			if pos.global_position.distance_to(player_pos) < nearest_pos.global_position.distance_to(player_pos):
				nearest_pos = pos
				enemy_pos = pos
				$Shoot.start()
		else:
			#teleports away from player
			if pos.global_position.distance_to(player_pos) > nearest_pos.global_position.distance_to(player_pos):
				nearest_pos = pos
				$Teleport.wait_time = 3
	old_pos = global_position		
	global_position = nearest_pos.global_position
	if old_pos != nearest_pos.global_position:
		AudioManager.play_sfx(KSkull, 2)
		shake.start()
	teleport_ok = false
	if damaged != false && spawned != true:
		damaged = false
		$AnimationPlayer.play("Spawn")
		$Spawn.start()
		
	if damaged != false:
		damaged = false
		set_state(IDLE)
	else:
		return
		
func _on_Timer_timeout():
	teleport_ok = true
		
func _on_Shoot_timeout():
	if shoot !=true && state != TELEPORT:
		return
	if !get_tree().get_root().get_node("Stage/Player").has_node("Player"):
		return
		
	fire_direction = (player.global_position - global_position).normalized()
	var laser = LASER.instance()
	get_tree().get_root().get_node("Stage/Enemies/King").add_child(laser)
	laser.set_position(global_position)
	laser.velocity = laser.velocity * fire_direction
	
	shoot = false
	
func death_state():
	boss_bar.queue_free()
	get_tree().get_root().get_node("Stage/Player/Player/RemoteTransform2D").queue_free()
	get_tree().get_root().get_node("Stage/HUD/PlayerHUD/HealthBarUI").visible = false
	if enemies_list.get_child_count() > 0:
		for child in enemies_list.get_children():
			if child is Skulls:
				child.blow_up()
				var boom = load("res://Assets/music/ExplosionV2.wav")
				AudioManager.play_sfx(boom, 0)
	if get_parent().has_node("Fire_Laser"):
		get_parent().get_node("Fire_Laser").queue_free()	
	if get_tree().get_root().get_node("Stage/Player").has_node("Waterball"):
		get_tree().get_root().get_node("Stage/Player/Waterball").destroy()
	var death_effect = DEATH_EFFECT.instance()
	get_parent().add_child(death_effect)
	death_effect.set_position(global_position)
	call_deferred("queue_free")

func player_killed():
	killed = true
			
func _on_Damage_received(health):
	teleport_ok = true
	damaged = true
	shoot = true
	if state == MOVE or state == IDLE && state != DEATH:
		set_state(TELEPORT)
	$Teleport.wait_time = 0.1
	if health <= 0:
		yield(get_tree().create_timer(0.3), "timeout")
		set_state(DEATH)

func _on_Spawn_timeout():
	set_state(SPAWN)
	
func play_talk():
	AudioManager.play_sfx(KSkull, 2)
	var positions = get_parent().get_node("Positions").get_children()
	var pos = positions[4]
	$AnimationPlayer.play("Normal")
	global_position = pos.global_position
	
func battle_begin():
	state = TELEPORT
	boss_bar.visible = true
	
