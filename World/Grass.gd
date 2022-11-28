extends Node2D


func create_grass_effect():
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

	#When area entered, destroy grass
func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
