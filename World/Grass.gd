extends Node2D


func _process(delta):
	if Input.is_action_just_pressed("attack"):
		#Load grass effect scene
		var GrassEffect = load("res://Effects/GrassEffect.tscn")
		#Make instance of that scene
		var grassEffect = GrassEffect.instance()
		#Get access to world scene
		var world = get_tree().current_scene
		#Add the instance in the world scene
		world.add_child(grassEffect)
		#Set global_position of grass effect at global_position of grass
		grassEffect.global_position = global_position
		#Remove grass
		queue_free()
