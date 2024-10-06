extends CharacterBody2D


const SPEED = 10.0
const JUMP_VELOCITY = -400.0
var ALIVE = true
var DIRECTION = -1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	velocity.x = DIRECTION * SPEED
	
	update_animations()
	move_and_slide()

func update_animations():
	if ALIVE:
		if DIRECTION != 0:
			animated_sprite_2d.flip_h = (DIRECTION > 0)
			animated_sprite_2d.play("walk")

	else:
		animated_sprite_2d.play("dead")
