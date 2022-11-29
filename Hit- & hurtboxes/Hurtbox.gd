extends Area2D

#Changeable bool so different scenes can turn off hit effect
export(bool) var show_hit = true

#Load the effect once
const HitEffect = preload("res://Effects/HitEffect.tscn")

func _on_Hurtbox_area_entered(area):
	if show_hit: 
		#Create instance of effect
		var effect = HitEffect.instance()
		#Get access to the scene we're in
		var main = get_tree().current_scene
		#Add the effect to that scene
		main.add_child(effect)
		#Set the position
		effect.global_position = global_position
