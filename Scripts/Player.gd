extends KinematicBody2D

var direction = Vector2()

const MAX_SPEED =1200

var speed = 0;
var motion = Vector2()

var target_pos = Vector2()
var target_direction = Vector2()
var is_moving = false;

var type
var grid

func cartesian_to_isometric(vector):
	return Vector2(vector.x - vector.y, (vector.x + vector.y) / 2)

func _ready():
	grid = get_parent().get_parent()
	type = grid.PLAYER
	

func _process(delta):
	direction = Vector2()
	speed = 0
	
	if Input.is_action_just_pressed("ui_up"):
		direction.y = -1
	elif Input.is_action_just_pressed("ui_down"):
		direction.y = 1

	if Input.is_action_just_pressed("ui_left"):
		direction.x = -1
	elif Input.is_action_just_pressed("ui_right"):
		direction.x = 1
		
	if not is_moving and direction != Vector2():
		target_direction = direction.normalized()
		if grid.is_cell_vacant(position,direction):
			target_pos = grid.update_child_pos(position,direction,type)
			is_moving = true
	elif is_moving:
		speed = MAX_SPEED
		
		motion =  cartesian_to_isometric(speed * target_direction * delta)
		
		var pos = position
		var distance_to_target = pos.distance_to(target_pos)
		var move_distance = motion.length()
		
		
		if move_distance > distance_to_target:
			position = target_pos
			is_moving = false
		else:
			position = pos + motion
