extends TextureProgress

onready var Damage_bar = $HurtWhite
onready var timer = $Timer

var damage = 0

func _ready():
	set_process(false)
	
func set_bar_value(value_to_set):
	damage = value - value_to_set
	value = damage
	timer.start()
	if value_to_set> Damage_bar.value:
		Damage_bar.value = value_to_set

func _process(_delta):
	Damage_bar.value = lerp(Damage_bar.value, value, 0.1)
	if (Damage_bar.value - value) <= 5:
		
		Damage_bar.value = value
		set_process(false)
		
func _on_Timer_timeout():
	set_process(true)


