extends Node2D

var powerup = preload("res://Scenes/PowerUP.tscn")

onready var player = get_node("Player")
onready var meteor = get_node("Player/Meteor")
onready var meteor2 = get_node("Player/Meteor2")
onready var meteor3 = get_node("Player/Meteor3")
onready var xp_bar = get_node("TextureProgress")
onready var camera = get_node("Camera2D")
onready var score = get_node("Score")
onready var animation = get_node("AnimationPlayer")
onready var restart_button = get_node("RestartButton")
onready var upgrade1_button = get_node("Upgrade1")
onready var upgrade2_button = get_node("Upgrade2")
onready var upgrade3_button = get_node("Upgrade3")
onready var tween = get_node("Tween")
onready var powers = get_node("Powers")

var upgrades = ["Faster Orb", "Bigger Orb", "Extra Health", "Extra Orb", "Move Faster", "Longer Shield", "Faster Upgrades", "Slower Enemies", "Heal Up"]
var max_orb_speed = 3.2
var max_orb_size = 1.8
var max_health = 5
var max_speed = 550
var max_invinc = 1.4
var max_upgrade_speed = 13
var min_enemy_speed = 18
var heals = 0
var max_heal = 3

var hearts = 2
var orbs = 1
var xp = 0
var max_xp = 18
var points = 0
var choice
var endgame = false

func _ready():
	randomize()
	get_node("Click").play()
	upgrade1_button.rect_global_position.y = 270
	upgrade2_button.rect_global_position.y = 270
	upgrade3_button.rect_global_position.y = 270
	restart_button.hide()
	get_node("Countdown").hide()
	xp_bar.get_node("Label").hide()
	meteor2.hide()
	meteor3.hide()
	meteor2.get_node("Area2D").monitoring = false
	meteor3.get_node("Area2D").monitoring = false
	score.text = str(points)
	fix_hp()
	xp_bar.value = 0
	xp_bar.max_value = max_xp
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func upgrade(item):
	match item:
		"Faster Orb":
			meteor.speed += 0.3
			meteor2.speed += 0.3
			meteor3.speed += 0.3
			if meteor.speed >= max_orb_speed:
				upgrades.erase("Faster Orb")
		"Bigger Orb":
			meteor.get_node("Area2D").scale += Vector2(0.2,0.2)
			meteor2.get_node("Area2D").scale += Vector2(0.2,0.2)
			meteor3.get_node("Area2D").scale += Vector2(0.2,0.2)
			if meteor.get_node("Area2D").scale.x >= max_orb_size:
				upgrades.erase("Bigger Orb")
		"Extra Health":
			hearts += 1
			player.health += 1
			fix_hp()
			if hearts >= max_health:
				upgrades.erase("Extra Health")
		"Extra Orb":
			if orbs == 1:
				meteor2.get_node("Area2D").monitoring = true
				meteor2.show()
			elif orbs == 2:
				meteor3.get_node("Area2D").monitoring = true
				meteor3.show()
				upgrades.erase("Extra Orb")
			orbs += 1
		"Move Faster":
			player.speed += 70
			if player.speed >= max_speed:
				upgrades.erase("Move Faster")
		"Longer Shield":
			player.invinc += 100
			if player.invinc >= max_invinc:
				upgrades.erase("Longer Shield")
		"Faster Upgrades":
			max_xp -= 1
			if max_xp <= max_upgrade_speed:
				upgrades.erase("Faster Upgrades")
		"Slower Enemies":
			get_node("Spawner").enemy_speed -= 3
			get_node("Spawner2").enemy_speed -= 3
			get_node("Spawner3").enemy_speed -= 3
			get_node("Spawner4").enemy_speed -= 3
			if get_node("Spawner").enemy_speed <= min_enemy_speed:
				upgrades.erase("Slower Enemies")
		"Heal Up":
			player.health = hearts
			fix_hp()
			heals += 1
			if heals >= max_heal:
				upgrades.erase("Heal Up")
		_:
			pass
	if upgrades.size() <= 3:
		xp_bar.get_node("Label").show()
		endgame = true

func fix_hp():
	for i in range(1,6):
		var node = get_node("Heart"+str(i))
		if i <= hearts:
			node.show()
		else:
			node.hide()
		if i <= player.health:
			node.frame = 1
		else:
			if node.frame == 1:
				node.get_node("Particle").emitting = true
			node.frame = 0

# warning-ignore:unused_argument
func hit(dmg):
	camera.apply_noise_shake()
	fix_hp()

func get_points():
	points += 5
	score.text = str(points)
	animation.play("score")

func get_xp():
	camera.apply_noise_shake()
	get_points()
	xp += 1
	xp_bar.value = xp
	if xp >= max_xp and not endgame:
		spawn_powerup()
		xp = 0
		xp_bar.value = 0

func spawn_powerup():
	var n = powerup.instance()
	n.position = Vector2(rand_range(24,296),rand_range(24,216))
	var v = Vector2(16,16)
	while n.position - player.global_position < v:
		n.position = Vector2(rand_range(24,296),rand_range(24,216))
	yield(get_tree(), "physics_frame")
	powers.add_child(n)

func game_over():
	restart_button.show()
	get_tree().paused = true

func show_upgrade():
	if endgame:
		return
	var pool = []
	var item = ""
	while pool.size() < 3:
		item = upgrades[randi() % upgrades.size()]
		if not pool.has(item):
			pool.append(item)
	
	upgrade1_button.text = pool[0]
	upgrade2_button.text = pool[1]
	upgrade3_button.text = pool[2]
	
	get_tree().paused = true
	move_upgrades_up()

func move_upgrades_up():
	get_node("Yay").play()
	tween.start()
	tween.interpolate_property(upgrade1_button, "rect_global_position", Vector2(25,270), Vector2(25,200), 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.interpolate_property(upgrade2_button, "rect_global_position", Vector2(123,270), Vector2(123,200), 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.interpolate_property(upgrade3_button, "rect_global_position", Vector2(222,270), Vector2(222,200), 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)

func move_upgrades_down():
	get_node("Aya").play()
	tween.start()
	tween.interpolate_property(upgrade1_button, "rect_global_position", Vector2(25,200), Vector2(25,270), 0.5, Tween.TRANS_BACK, Tween.EASE_IN)
	tween.interpolate_property(upgrade2_button, "rect_global_position", Vector2(123,200), Vector2(123,270), 0.5, Tween.TRANS_BACK, Tween.EASE_IN)
	tween.interpolate_property(upgrade3_button, "rect_global_position", Vector2(222,200), Vector2(222,270), 0.5, Tween.TRANS_BACK, Tween.EASE_IN)
	get_node("Cursor").speed = meteor.speed

func _on_RestartButton_pressed():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func _on_Upgrade1Button_pressed():
	move_upgrades_down()
	choice = upgrade1_button.text
	animation.play("count")

func _on_Upgrade2Button_pressed():
	move_upgrades_down()
	choice = upgrade2_button.text
	animation.play("count")

func _on_Upgrade3Button_pressed():
	move_upgrades_down()
	choice = upgrade3_button.text
	animation.play("count")

func unpause():
	get_tree().paused = false
	upgrade(choice)

func _on_Upgrade1Button_mouse_entered():
	upgrade1_button.rect_scale = Vector2(1.05,1.05)

func _on_Upgrade1Button_mouse_exited():
	upgrade1_button.rect_scale = Vector2(1.0,1.0)


func _on_Upgrade2Button_mouse_entered():
	upgrade2_button.rect_scale = Vector2(1.05,1.05)

func _on_Upgrade2Button_mouse_exited():
	upgrade2_button.rect_scale = Vector2(1.0,1.0)


func _on_Upgrade3Button_mouse_entered():
	upgrade3_button.rect_scale = Vector2(1.05,1.05)

func _on_Upgrade3Button_mouse_exited():
	upgrade3_button.rect_scale = Vector2(1.0,1.0)
