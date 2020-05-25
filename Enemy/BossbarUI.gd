extends Control
signal damaged(health)

onready var KSkull = get_tree().get_root().get_node("Stage/Enemies/King/King")
var value = 0

func damage_boss():
	value = 10

	$GUI/MainRed.set_bar_value(value)
	get_parent().get_node("ScreenShake").start(0.2, 15, 5)
	emit_signal("damaged", $GUI/MainRed.value)
