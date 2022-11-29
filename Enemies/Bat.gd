extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

var knockback = Vector2.ZERO

onready var stats = $Stats


func _physics_process(delta):
	#Always moves knockback towards zero(friction)
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	#Makes the bat move when knockback is not zero
	knockback = move_and_slide(knockback)

	#area = the area that entered
func _on_Hurtbox_area_entered(area):
	#Lower the health
	stats.health -= area.damage
	#Set knockback by direction and multiplier
	knockback = area.knockback_vector * 100


func _on_Stats_no_health():
	queue_free()
	#Make instance of scene
	var enemyDeathEffect = EnemyDeathEffect.instance()
	#Add scene to the world scene
	get_parent().add_child(enemyDeathEffect)
	#Set the position
	enemyDeathEffect.global_position = global_position
