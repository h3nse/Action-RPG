extends Node

#Export so we can change it in editor
export(int) var max_health = 1
#setget calls the function set_health whenever health changes
onready var health = max_health setget set_health

#Create custom signal
signal no_health

func set_health(value):
	health = value
	#Emit signal if health is <= 0
	if health <= 0:
		emit_signal("no_health")
