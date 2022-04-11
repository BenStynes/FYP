class_name Combatant
extends Node

export(int) var damage = 1
export(int) var defense = 1
var active = false setget set_active

signal turn_finished

func set_active(value):
	active = value
	set_process(value)
	set_process_input(value)
	
	if not active:
		return
	if $Health.armor >= $Health.base_armour + defense:
		$Health.armor = $Health.base_armor


func attack(target):
	target.take_damage(damage)
	emit_signal("turn_finished")


func consume(item):
	item.use(self)
	emit_signal("turn_finished")# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func defend():
	$Health.armor += defense # Replace with function body.
	emit_signal("turn_finished")


func take_damage(damage_to_take):
	$Health.take_damage(damage_to_take)
	$Sprite/AnimationPlayer.play("take_damage")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
