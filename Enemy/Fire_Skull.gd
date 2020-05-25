extends KinematicBody2D
signal anim_over

export var ACCELERATION = 900
export var MAX_SPEED = 80
export var FRICTION = 900
export var Search = true
export var Shoot = true

var velocityEnemy = Vector2.ZERO

const FIREBALL = preload("res://Enemy/Fireball.tscn")
const DEATH = preload("res://Enemy/FireSkullEffect.tscn")
onready var fire_rate = $Fire_Rate

enum {
	IDLE
	MOVE
}
var state = MOVE

func _ready():
	print("spawned")
	
func _physics_process(delta):
	if Shoot == true:
		fire_rate.start()
		Shoot = false

	if Search != true:
		state = IDLE
	else:
		state = MOVE
		
	match state:
		IDLE:
			idle_state()
		MOVE:
			move_state(delta)
			
func idle_state():
	velocityEnemy = Vector2.ZERO
	
func move_state(delta):
	var player = $PlayerDetection.player
	
	if player != null && fire_rate.is_stopped():	
		var direction = (player.global_position - global_position).normalized() 
		velocityEnemy = velocityEnemy.move_toward( direction * MAX_SPEED, ACCELERATION * delta)
		
	elif player != null && !fire_rate.is_stopped():
		var direction = (player.global_position - global_position).normalized() 
		var distance = global_position.distance_to(player.global_position)
		if distance >= 50:
			velocityEnemy = velocityEnemy.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		else:
			velocityEnemy = Vector2.ZERO
		
	else:
		velocityEnemy = velocityEnemy.move_toward(Vector2.ZERO, FRICTION * delta)	
	
	velocityEnemy = move_and_slide(velocityEnemy)	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider == player:
			player.damage(1)

func _on_Hitbox_body_entered(body):
	if body.name == "Waterball":
		body.destroy()
		blow_up()
		
func blow_up():
	var death = DEATH.instance()
	get_parent().add_child(death)
	death.set_position(get_global_position())
	queue_free()
			
func _on_Fire_Rate_timeout():
	var player = $PlayerDetection.player
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		shoot_fire(direction)
	else:
		pass
	
func shoot_fire(direction):
	print("called fire")
	fire_rate.start()
	var fireball = FIREBALL.instance()
	get_tree().get_root().get_node("Stage/Enemies").add_child(fireball) 
	fireball.set_position($firebal_spawn.get_global_position())
	fireball.velocity = fireball.velocity* direction
   
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Gag1_Bro2":
		emit_signal("anim_over")
		
