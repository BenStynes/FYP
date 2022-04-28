extends Pawn

#warning-ignore:unused_class_variable
export(PackedScene) var combat_actor
#warning-ignore:unused_class_variable
var lost = false
var move_Spaces = 4
func _ready():
	pass#set_process(false)
func _Process(delta):
	astar

func endTurn():
	set_process(false)
	#yield(parent.get_Child(0),"turn_done")
