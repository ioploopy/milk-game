extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const ACCELERATION = 800
const FRICTION = 1000
const ALIVE = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D
var on_ladder: int = 0
var jumping: bool = false

func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	handle_ladder(delta)
	var input_axis = Input.get_axis("ui_left", "ui_right")
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	update_animations(input_axis)
	move_and_slide()

func apply_gravity(delta):
		if not is_on_floor() and on_ladder == 0:
			velocity.y += gravity * delta
			
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


func _on_ladder_detector_area_entered(area):
	on_ladder+=1
	print(on_ladder)

func _on_ladder_detector_area_exited(area):
	on_ladder-=1
	print(on_ladder)
	
