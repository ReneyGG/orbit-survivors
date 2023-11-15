extends Area2D

onready var player = get_node("/root").get_node("Main").get_node("Player")
onready var animation = get_node("AnimationPlayer")
onready var pop_sfx = get_node("Pop")

var speed = 30

func _ready():
	get_node("Sprite").visible = true

func _physics_process(delta):
	if player == null:
		return
	
	global_position = global_position.move_toward(player.get_global_position(), delta * speed)

func _on_Enemy_area_entered(area):
	if area.has_method("hit"):
		area.hit(1)
		animation.play("hit")

# warning-ignore:unused_argument
func hit(dmg):
	pop_sfx.play()
	animation.play("hit")
