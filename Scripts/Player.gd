extends Area2D

# warning-ignore:unused_signal
signal game_over
signal hit(dmg)

export (PackedScene) var Bullet

onready var animation = get_node("AnimationPlayer")
onready var smooth = get_node("Smooth")
onready var switch = get_node("Switch")

var invinc = 0.4
var health = 2
var speed = 200

func _ready():
# warning-ignore:return_value_discarded
	connect("hit", get_node("/root").get_node("Main"), "hit")
# warning-ignore:return_value_discarded
	connect("game_over", get_node("/root").get_node("Main"), "game_over")
	monitorable = true
	get_node("Sprite").visible = true

func _physics_process(delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("orbit"):
		switch.play()
		smooth.play("orbit")
	
	var target = get_global_mouse_position()
	position = position.move_toward(target, delta * speed)

func hit(dmg):
	health -= dmg
	emit_signal("hit",dmg)
	animation.play("hit")
	if health <= 0:
		animation.play("over")
		return
	get_node("Hit").play()
