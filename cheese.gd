extends CharacterBody2D


@export var SPEED = 10.0
@export var MOVE_DISTANCE = 100

var ALIVE = true
var DIRECTION = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var collision_shape_area_2d = $Area2D/CollisionShape2D

var start_pos: Vector2

func _ready():
	start_pos = global_position

func _physics_process(delta):
	
	if not ALIVE:
		return	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if DIRECTION == 1 and (global_position.x - start_pos.x) >= MOVE_DISTANCE:
		DIRECTION = -1
	if DIRECTION == -1 and (global_position.x - start_pos.x) <= 0:
		DIRECTION = 1
		
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

func kill_cheese():
	ALIVE = false
	animated_sprite_2d.play("dead")
	collision_shape_2d.shape.set_size(Vector2(14,1))
	collision_shape_area_2d.shape.set_size(Vector2(11,1))

func _on_area_2d_body_entered(body):
	if body.has_method("kill_player") and ALIVE:
		var response = (body.kill_player(true))
		if response.jumping:
			self.kill_cheese()
		
