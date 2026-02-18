extends Node2D


func _ready():
	$Instructions.visible = false
	$Play2.visible = false
	$Play2.disabled = true

func _on_play_pressed():
	$Instructions.visible = true
	$Play.disabled = true
	$Play2.visible = true
	$Play2.disabled = false


func _on_play_2_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/main_level.tscn")

func _process(_delta):
	if $AudioStreamPlayer2D.playing == false:
		$AudioStreamPlayer2D.playing = true
