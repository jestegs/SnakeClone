extends Node
# alt name: Materiel - military supplies, look it up
# - can plant guns with points, versus enemy train

onready var hud = $HUD
onready var grid = $Level
onready var snake_head = $Level/SnakeHead
var score

onready var Food = preload("res://snake/Food.tscn")
var food

var grid_size = Vector2(45, 45)


func _ready():
	grid.build_grid(grid_size)
	start_game()
	hud.get_node("EndScreen/Button").connect("pressed", self, "start_game")
	gen_food()


func _process(_delta):
	# eat food:
	if snake_head.position == food.position:
		snake_head.grow()
		food.queue_free()
		score += 10
		hud.get_node("Score").text = str(score)
		hud.get_node("EndScreen/Score").text = str(score)
		gen_food()


func start_game():
	snake_head.position = grid.map_to_world(Vector2(3, 40))
	snake_head.restart_worm()
	score = 0
	hud.get_node("EndScreen").visible = false
	hud.get_node("Score").text = str(score)
	hud.get_node("EndScreen/Score").text = str(score)


func game_over():
	hud.get_node("EndScreen").visible = true


func gen_food():
	var location = Vector2(
		randi() % int(grid_size.x-3) + 1,
		randi() % int(grid_size.y-3) + 1
	)
	food = Food.instance()
	add_child(food)
	food.position = grid.map_to_world(location)


func _on_SnakeHead_hit_obstacle():
	game_over()
