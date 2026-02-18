extends CharacterBody2D

var direction = Vector2(0, 1)
var speed = 30
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
	
	var texture = load("res://assets/enemies/Untitled28_20250606165240.png")

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


func _on_timer_timeout():
	var dir1 = rng.randf_range(-1, 1)
	var dir2 = rng.randf_range(-1, 1)

	direction = Vector2(dir1, dir2)
