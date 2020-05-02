extends KinematicBody2D


const GAP = 16
const BASE_SPEED = 60
const INIT_DIRECTION = Vector2(1,0)
const INITIAL_COORD = Vector2(72, 72)

var score = 0
var flag = false
var pause = -1

onready var direction = Vector2(1,0)
onready var tail = preload("res://Tail.tscn")

var step = 1
var speed = step * BASE_SPEED
var stored_vector = Vector2.ZERO
var body = null
var command_list = []
var alive = false
var start = true

func _ready():
	position = INITIAL_COORD
	body = get_child(2)
	
	
	
	
func update_tail():
	var pos = position
	var dir = direction
	for i in range(body.get_child_count()):
		var child = body.get_child(i)
		child.add_location(dir, pos)
		pos = child.update_node()
		child.set_global_position(pos+ dir * (step-1) * GAP)
		
		
		
func update_move_direction():
	if stored_vector != Vector2.ZERO:
		pass
	elif Input.is_action_just_pressed("ui_down") and direction.y != -1:
		stored_vector.y = 1
		flag = true
	elif Input.is_action_just_pressed("ui_up") and direction.y != 1:
		stored_vector.y = -1
		flag = true
	elif Input.is_action_just_pressed("ui_left") and direction.x != 1:
		stored_vector.x = -1
		flag = true
	elif Input.is_action_just_pressed("ui_right") and direction.x != -1:
		stored_vector.x = 1
		flag = true
	
	
	if direction != stored_vector * -1 and stored_vector != Vector2.ZERO and flag:
		if int(position.x + 8) % 16 == 0 && int(position.y + 8) % 16 == 0:
			direction = stored_vector
			flag = false
			stored_vector = Vector2.ZERO

func _physics_process(delta):
	if alive:
		if Input.is_action_just_pressed("pause"):
			pause *= -1
		if pause == 1:
			get_parent().get_node("Pause").visible = true
		else:
			get_parent().get_node("Pause").visible = false
			
			update_move_direction()
			move_and_slide(direction * speed )
			if is_on_wall():
				get_parent().get_node("Pause").set_text("GAME OVER\npress enter to continue\n Score="+str(score))
				get_parent().get_node("Pause").visible = true
				alive = false
				
			update_tail()
	elif start:
		if Input.is_action_just_pressed("enter"):
			start = false
			alive = true
			get_parent().get_node("Start").visible = false
			add_tail()	
	else:
		if Input.is_action_just_pressed("enter"):
			get_tree().change_scene("res://World.tscn")
			
		
func add_tail():
	var tail_child = tail.instance()
	var tail_nodes = body.get_child_count()
	var cor = null
	var dir = null

	if tail_nodes == 0:
		cor = INITIAL_COORD
		dir = INIT_DIRECTION
		tail_child.name = "2"
	else:
		var child = body.get_child(tail_nodes - 1)
		cor = child.global_position
		dir = child.g_direction

	tail_child.global_position = cor - GAP*dir
	print(global_position)
	tail_child.g_direction = dir
	for i in range(0, GAP):
		tail_child.add_location(dir, cor+ (i+1)*dir - GAP * dir)
	body.add_child(tail_child)

