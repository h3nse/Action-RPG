extends Node2D

#Set variable for animated sprite node
onready var animatedSprite = $AnimatedSprite

func _ready():
	#Set starting frame to 0 and play animation
	animatedSprite.frame = 0
	animatedSprite.play("Animate")

#When getting signal that animation has ended, remove grass effect
func _on_AnimatedSprite_animation_finished():
	queue_free()
