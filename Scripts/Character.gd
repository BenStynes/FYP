extends KinematicBody2D

var tile_size = 64;
var move_time = 0.25;
var terrain = null;

func _ready():
	terrain = get_tree().get_nodes_in_group("terrain")
	terrain = terrain[0]

func _process(delta):
	
	if not $Tween.is_active():
		if Input.is_action_just_pressed("ui_left"):
			_move(Vector2(-1,0));
		if Input.is_action_just_pressed("ui_right"):
			_move(Vector2(1,0));
		if Input.is_action_just_pressed("ui_up"):
			_move(Vector2(0,-1));
		if Input.is_action_just_pressed("ui_down"):
			_move(Vector2(0,1));
		
func _move(direction):
	var tile = Vector2(int(position.x/tile_size),int(position.y/tile_size))
	if terrain.get_cellv(tile + direction) == -1:
		if direction.x != 0:
			$Tween.interpolate_property(self,"position:x",position.x,position.x+direction.x*tile_size,move_time,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		else:
			$Tween.interpolate_property(self,"position:y",position.y,position.y+direction.y*tile_size,move_time,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start();
