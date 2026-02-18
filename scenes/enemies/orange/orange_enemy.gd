extends CharacterBody2D

var direction = Vector2(1, 0)
var speed = 35
var friction = 700
var acceleration = 1500

var pos = Vector2.ZERO

var player_here = false
var rng = RandomNumberGenerator.new()
var sprite = int(rng.randf_range(1, 3))



func _ready():
	
	var x = rng.randf_range(-2500, 1500)
	var y = rng.randf_range(-2500, 1500)
	
	while x > -200 and x < 200: x = rng.randf_range(-2500, 1500)
	while y > -200 and y <200: y = rng.randf_range(-2500, 1500)
	
	var texture = load("res://assets/enemies/orange" + str(sprite)+ ".png")

	$Sprite2D.texture  = texture
	
	global_position = Vector2(x, y)
	pos = global_position

func _physics_process(delta):
	#movement code
	if direction == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * friction * delta
			rotation += 0.01
		else:
			velocity = Vector2.ZERO
	else:
		rotation += 0.01
		velocity += (direction * acceleration * delta)
		velocity = velocity.limit_length(speed)
	
	move_and_slide()
	
	if modulate.a == 0:
		queue_free()

func _on_timer_timeout():
	var dir1 = rng.randf_range(-1, 1)
	var dir2 = rng.randf_range(-1, 1)

	direction = Vector2(dir1, dir2)


func _on_area_2d_body_entered(body):
	if body.disguised == false and body.level < 2:
		var dir1 = body.position.x - position.x
		var dir2 = body.position.y - position.y
		
		direction = Vector2(dir1, dir2).normalized() * -1
		speed = 500
		$RunTimer.start()

func _on_run_timer_timeout():
	speed = 35
		
