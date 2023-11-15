extends Node2D

export var lock_y = true
export var enemy_speed = 30
export var delay = 0.0

onready var SpawnTimer = get_node("Timer")
onready var DelayTimer = get_node("Delay")
onready var Main = get_parent()

var enemy = preload("res://Scenes/Enemy.tscn")
var spawn_rate
var max_rate = 0.4

func _ready():
	randomize()
	DelayTimer.start(delay)

func rate():
# warning-ignore:unused_variable
	var points = Main.points/5
	spawn_rate = (abs(Main.points)/200.0)*(-1)+4
	if spawn_rate <= max_rate:
		spawn_rate = max_rate

func _on_Timer_timeout():
	var enemy_instance = enemy.instance()
	if lock_y:
		enemy_instance.global_position = Vector2(rand_range(-16,336),global_position.y)
	else:
		enemy_instance.global_position = Vector2(global_position.x, rand_range(-16,256))
	enemy_instance.speed = enemy_speed
	add_child(enemy_instance)
	rate()
	SpawnTimer.start(spawn_rate)

func _on_Delay_timeout():
	_on_Timer_timeout()
