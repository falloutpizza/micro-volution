extends CharacterBody2D

var speed = 300
var friction = 600
var acceleration = 1500

var input = Vector2.ZERO

var health = 1000
var max_health = 1000

var died = false
var won = false

var points = 0 #CHANGE
var max_points = 400

var level = 0
var disguised = false

func _ready():
	$Disguise.visible = false

func get_input():
	input.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	input.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	return input.normalized()

func _physics_process(delta):
	#movement code
	
	if not died and not won:
		input = get_input()
		
		if input == Vector2.ZERO:
			if velocity.length() > (friction * delta):
				velocity -= velocity.normalized() * friction * delta
				rotation += 0.007
			else:
				velocity = Vector2.ZERO
		else:
			rotation += 0.01
			health -= 0.25
			velocity += (input * acceleration * delta)
			velocity = velocity.limit_length(speed)
		
		move_and_slide()

func _process(_delta):
	if not died and not won:
		if disguised == true:
			$Disguise.rotation -= 0.02
		if points >= 100 and Input.is_action_just_pressed("disguise"):
			disguised = true
			$DisguiseTimer.start()
			$Disguise.visible = true
	if health <= 0:
		var tween = get_tree().create_tween()
		tween.tween_property($".", "scale", scale*1.01, 0.3)
		tween.set_parallel().tween_property($".", "modulate:a", 0, 0.3)

		died = true
		
#for deciding evolutions
func evolve(num):
	if num == 1: speed = speed + 60
	if num == 2: max_health = max_health + 200
	if num == 3: $DisguiseTimer.wait_time += 2

#for eating and being eaten
func _on_detector_body_entered(body):
	var tween = get_tree().create_tween()
	#blue body
	if body.get_collision_layer() == 2:
		if points <= max_points - 20:
			points += 20
		health += 100
		if health > 1000: health = 1000

		tween.tween_property(body, "scale", body.scale*1.2, 0.1)
		tween.set_parallel().tween_property(body.get_child(3), "modulate:a", 1, 0.1)

		
	#yellow body
	elif body.get_collision_layer() == 4:
		if points >= 100 and level == 0 and disguised == true:

			evolve(body.sprite)
			body.collision_layer = 128
			body.collision_mask = 128
			
			tween.tween_property($'.', "global_position", body.global_position, 0.3)
			tween.tween_property(body, "modulate:a", 0 , 0.3)
			tween.set_parallel().tween_property(body, "scale", scale*0.7 , 0.3)
			tween.tween_property($'.', "scale", scale*1.3, 0.6)
			
			$Color.color = Color.GOLD
			points = points - 100
			level = 1
			health += 150
			if health > 1000: health = 1000

		elif level >= 1:
			body.queue_free()
			points = points + 50
			if points > max_points: points = max_points
			health += 150
			if health > 1000: health = 1000

		else:
			health = health - 100
	
	#orange body
	elif body.get_collision_layer() == 8:
		if points >= 200 and level == 1 and disguised == true:

			evolve(body.sprite)
			body.collision_layer = 128
			body.collision_mask = 128
			
			tween.tween_property($'.', "global_position", body.global_position, 0.3)
			tween.tween_property(body, "modulate:a", 0 , 0.3)
			tween.set_parallel().tween_property(body, "scale", scale*0.7 , 0.3)
			tween.tween_property($'.', "scale", scale*1.3, 0.6)

			$Color.color = Color.DARK_ORANGE
			points = points - 100
			level = 2
			health += 200
			if health > 1000: health = 1000

		elif level >= 2:
			body.queue_free()
			points = points + 75
			if points > max_points: points = max_points
			health += 200
			if health > 1000: health = 1000

		else: health = health - 100

#red body
	elif body.get_collision_layer() == 16:
		if points >= max_points and disguised == true and level == 2:
			$Color.color = Color.DARK_RED
			$Disguise.visible = false

			tween.tween_property($'.', "global_position", body.global_position, 0.3)
			tween.tween_property(body, "modulate:a", 0 , 0.3)
			tween.set_parallel().tween_property(body, "scale", scale*0.7 , 0.3)
			tween.tween_property($'.', "scale", scale*4, 0.6).set_ease(Tween.EASE_IN)

			won = true
			
		else:
			health = health - 250

func _on_disguise_timer_timeout():
	disguised = false
	$Disguise.visible = false
