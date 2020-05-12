extends Node2D

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var GrassEfect = load("res://Effects/GrassEffect.tscn")
		var grassEffect = GrassEfect.instance()		
		var world = get_tree().current_scene
		world.add_child(grassEffect)
		grassEffect.global_position = global_position
		queue_free()
