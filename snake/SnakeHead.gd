extends Sprite


signal hit_obstacle


var opposites = {
	Vector2(0, -1):Vector2.DOWN,
	Vector2(0, 1):Vector2.UP,
	Vector2(-1, 0):Vector2.RIGHT,
	Vector2(1, 0):Vector2.LEFT
}

onready var grid = get_parent()
var move_direction = Vector2.RIGHT
var end_pos:Vector2
var prev_move_direction = move_direction
var time_since_move = 0
var move_delay = .075
var is_game_over:bool = false

onready var Tail = preload("res://snake/Tail.tscn")
var tails:Array


func restart_worm():
	move_delay = .075
	is_game_over = false
	move_direction = Vector2.RIGHT
	prev_move_direction = move_direction
	for tail in tails:
		tail.queue_free()
	tails.clear()


func _process(delta):
	time_since_move += delta
	
	if not is_game_over:
		if Input.is_action_just_pressed("move_up"):
			move_direction = Vector2.UP
		elif Input.is_action_just_pressed("move_right"):
			move_direction = Vector2.RIGHT
		elif Input.is_action_just_pressed("move_down"):
			move_direction = Vector2.DOWN
		elif Input.is_action_just_pressed("move_left"):
			move_direction = Vector2.LEFT
		
		if opposites[move_direction] == prev_move_direction:
			move_direction = prev_move_direction
		
		if Input.is_action_just_pressed("debug_grow"):
			for i in range(10):
				grow()
		
		for tail in tails:
			if tail.position == position:
				emit_signal("hit_obstacle")
		
	if time_since_move >= move_delay:
		prev_move_direction = move_direction
		if is_game_over:
			move_delay = .04
			move_tail()
		else:
			make_a_move()


func make_a_move():
	if not grid.request_move(self, move_direction):
		emit_signal("hit_obstacle")
	
	move_tail()


func move_tail():
	time_since_move = 0
	var prev_head_pos = position - grid.map_to_world(prev_move_direction)
	end_pos = position
	
	if tails.size() >= 1:
		var tail = tails.pop_back()
		tail.visible = true
		if is_game_over:
			tail.visible = false
		tails.push_front(tail)
		end_pos = tail.position
		tail.position = prev_head_pos


func grow():
	var new_tail = Tail.instance()
	get_parent().add_child(new_tail)
	tails.append(new_tail)
	new_tail.visible = false
	#grid.set_cellv(grid.world_to_map(end_pos), grid.TAIL)


func _on_SnakeHead_hit_obstacle():
	is_game_over = true
