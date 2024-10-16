extends StaticBody2D

@onready var fridge_sprite_2d = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	fridge_sprite_2d.play("throw")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
