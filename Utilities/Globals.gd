extends Node2D

var intro = false setget set_intro, get_intro
var gag = null setget set_gag

func _ready():
	pass # Replace with function body.
	
func set_intro(value):
	intro = value

func set_gag(value):
	gag = value

func get_intro():
	return intro


