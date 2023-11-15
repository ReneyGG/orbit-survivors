extends Area2D

signal powerup

func _ready():
# warning-ignore:return_value_discarded
	connect("powerup", get_node("/root").get_node("Main"), "show_upgrade")
	get_node("CPUParticles2D").emitting = true
	get_node("Pop").play()

func _physics_process(delta):
	get_node("Sprite").rotate(2.0 * delta)

func _on_PowerUP_area_entered(area):
	if area.has_method("hit"):
		emit_signal("powerup")
		queue_free()
