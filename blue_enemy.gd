extends CharacterBody2D

var direction = Vector2(0, 1)
var speed = 100
var friction = 700
var acceleration = 1500

var pos = Vector2.ZERO
var rng = RandomNumberGenerator.new()

func _ready():
	var x = rng.randf_range(-2500, 1500)
	var y = rng.randf_range(-2500, 1500)
	global_position = Vector2(x, y)
	pos = global_position

func _physics_process(delta):
	#movement code
	rotation += 0.0075
	if direction == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * friction * delta
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (direction * acceleration * delta)
		velocity = velocity.limit_length(speed)
	
	move_and_slide()
	if $Color.modulate.a == 1:
		queue_free()

func _on_timer_timeout():
	var dir1 = rng.randf_range(-1, 1)
	var dir2 = rng.randf_range(-1, 1)

	direction = Vector2(dir1, dir2)
