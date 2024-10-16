extends RigidBody2D

@export var STARTING_VELOCITY = Vector2(-200,-200)
@export var SPIN_SPEED = -20
@onready var timer = $Timer

var reset_state = false

var starting_position = position

# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = STARTING_VELOCITY
	angular_velocity = SPIN_SPEED
	starting_position = position
	

func _integrate_forces(state):
	if reset_state:
		state.transform = Transform2D(0., starting_position)
		reset_state = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	



func _on_timer_timeout():
	linear_velocity = STARTING_VELOCITY
	angular_velocity = SPIN_SPEED
	reset_state = true





func _on_area_2d_body_entered(body):
	if body.has_method("kill_player") and linear_velocity != Vector2(0,0):
		body.kill_player()
