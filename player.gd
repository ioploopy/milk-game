extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const ACCELERATION = 800
const FRICTION = 1000
const DEAD_DEPTH = 1000
var ALIVE = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D
var on_ladder: int = 0
var jumping: bool = false
var airborn: bool = false
@onready var menu_timer = $MenuTimer

func _physics_process(delta):
	apply_gravity(delta)
	var input_axis = 0
	
	if ALIVE:
		handle_jump()
		handle_ladder(delta)
		input_axis = Input.get_axis("ui_left", "ui_right")
		
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	update_animations(input_axis)
	move_and_slide()
	check_depth()

func apply_gravity(delta):
		if not is_on_floor() and on_ladder == 0:
			airborn = true
			velocity.y += gravity * delta
		else:
			if airborn == true:
				airborn = false
						
func handle_jump():
	if is_on_floor() or on_ladder > 0:
		if Input.is_action_just_pressed("ui_accept"):
			jumping = true
			velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("ui_accept") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2
	if Input.is_action_just_released("ui_accept"):
		jumping=false 
	

func handle_ladder(delta):
	if on_ladder and not jumping:
		if Input.is_action_pressed("ui_down"):
			velocity.y=SPEED*delta*50
		elif Input.is_action_pressed("ui_up"):
			velocity.y=-SPEED*delta*50
		else:
			velocity.y=0

func handle_acceleration(input_axis, delta):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED*input_axis, ACCELERATION*delta)

func apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION*delta)

func update_animations(input_axis):
	if ALIVE:
		if input_axis != 0:
			animated_sprite_2d.flip_h = (input_axis < 0)
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
		
		if not is_on_floor():
			animated_sprite_2d.play("jump")
	else:
		animated_sprite_2d.play("dead")

func check_depth():
	if position.y > DEAD_DEPTH:
		_kill_player()


func _kill_player():
	ALIVE = false
	
	if menu_timer.is_stopped():
		menu_timer.start()
	

func kill_player(unless_airborn=false, airborn_safe_direction=""):
	var landed = true
	if unless_airborn:
		landed = not airborn
		if landed:
			self._kill_player()
		else:
			match airborn_safe_direction:
				"up":
					if velocity.y > 0:
						self._kill_player()
				"down":
					if velocity.y < 0:
						self._kill_player()
	else:
		self._kill_player()
		
	return {"alive": ALIVE, "airborn": not landed}


func _on_ladder_detector_area_entered(area):
	on_ladder+=1

func _on_ladder_detector_area_exited(area):
	on_ladder-=1
	
func _on_menu_timer_timeout():
	get_tree().change_scene_to_file("res://start_menu.tscn")
