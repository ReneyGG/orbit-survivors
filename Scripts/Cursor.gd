extends Sprite

var speed = 2.0

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_pressed("orbit"):
		speed *= -1
	
	rotate(speed * delta)
	global_position = get_global_mouse_position()
