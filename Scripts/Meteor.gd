extends Node2D

signal get_xp

var speed = 1.7

func _ready():
# warning-ignore:return_value_discarded
	connect("get_xp", get_node("/root").get_node("Main"), "get_xp")

func _physics_process(delta):
	if Input.is_action_just_pressed("orbit"):
		speed *= -1
	rotate(speed * delta)

func _on_Area2D_area_entered(area):
	if area.has_method("hit"):
		area.hit(1)
		emit_signal("get_xp")
