extends Node
signal pan_in

const TRANS = Tween.TRANS_CUBIC
const EASE = Tween.EASE_IN_OUT

var amplitude_x = 0
var amplitude_y = 0

onready var camera = get_parent()

# warning-ignore:shadowed_variable
func start(frequency, x, y):
	self.amplitude_x = x
	self.amplitude_y = y
	
	$Frequency.wait_time = 1 / float(frequency)
	$Frequency.start()
	_new_pan()

func _new_pan():
	var rand = Vector2()
	rand.x = amplitude_x
	rand.y = amplitude_y
	
	$Tween.interpolate_property(camera, "offset", camera.offset, rand, $Frequency.wait_time, TRANS, EASE)
	$Tween.start()
	yield(get_tree().create_timer($Frequency.wait_time), "timeout")
	emit_signal("pan_in")
	
func _reset():
	$Tween.interpolate_property(camera, "offset", camera.offset, Vector2(), $Frequency.wait_time, TRANS, EASE)
	$Tween.start()
	
func stop():
	$Frequency.wait_time = 2
	_reset()
	$Frequency.stop()
	
func complete_stop():
	$Tween.stop_all()
	camera.offset.x = 0
	camera.offset.y = 0
