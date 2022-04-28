extends KinematicBody2D
var triggered = false;


func _trigger():
	if triggered == true:
		hide()
		visible = false


