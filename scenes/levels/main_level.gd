extends Node2D


var blue_enemy = preload("res://scenes/enemies/blue/blue_enemy.tscn")
var yellow_enemy = preload("res://scenes/enemies/yellow/yellow_enemy.tscn")
var orange_enemy = preload("res://scenes/enemies/orange/orange_enemy.tscn")
var red_enemy = preload("res://scenes/enemies/red/red_enemy.tscn")


func _ready():
	$CanvasLayer/LosingLevel.visible = false
	$CanvasLayer/LosingLevel/Play.disabled = true
	$CanvasLayer/WinningText.visible = false
	for i in range(25):
		var child_node = blue_enemy.instantiate()
		$BlueEnemies.add_child(child_node)
	for i in range(15):
		var child_node = yellow_enemy.instantiate()
		$YellowEnemies.add_child(child_node)
	for i in range(15):
		var child_node = orange_enemy.instantiate()
		$OrangeEnemies.add_child(child_node)
	for i in range(5):
		var child_node = red_enemy.instantiate()
		$RedEnemies.add_child(child_node)

func _process(_delta):
	if $AudioStreamPlayer2D.playing == false:
		$AudioStreamPlayer2D.playing = true
	if $Player.won != true and $Player.died != true:
		$CanvasLayer/ProgressBar/RichTextLabel.text = str($Player.points)
		$CanvasLayer/ProgressBar/ColorRect2.size.x = $Player.points*0.5
		$CanvasLayer/HealthBar/ColorRect2.size.x = ($Player.health*231)/$Player.max_health
	if $BlueEnemies.get_child_count() < 20:
		for i in range(5):
			var child_node = blue_enemy.instantiate()
			$BlueEnemies.add_child(child_node)
	if $YellowEnemies.get_child_count() < 10:
		for i in range(5):
			var child_node = yellow_enemy.instantiate()
			$YellowEnemies.add_child(child_node)
	if $OrangeEnemies.get_child_count() < 10:
		for i in range(5):
			var child_node = orange_enemy.instantiate()
			$OrangeEnemies.add_child(child_node)
	if $Player.died == true:
		$CanvasLayer/LosingLevel.visible = true
		$CanvasLayer/LosingLevel/Play.disabled = false
		$CanvasLayer/ProgressBar.visible = false
		$CanvasLayer/HealthBar.visible = false
		if $Player.modulate.a == 0:
			$Player.queue_free()
		
	if $Player.won == true:
		$CanvasLayer/WinningText.visible = true
		$CanvasLayer/ProgressBar.visible = false
		$CanvasLayer/HealthBar.visible = false
