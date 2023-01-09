extends KinematicBody2D

#Load once
const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

#Make variables
export var acceleration = 300
export var max_speed = 50
export var friction = 200

#State machine
enum {
	IDLE,
	WANDER,
	CHASE
}

#Make variables
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

#Set loaded state to IDLE
var state = IDLE

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox

func _physics_process(delta):
	#Always moves knockback towards zero(friction)
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	#Makes the bat move when knockback is not zero
	knockback = move_and_slide(knockback)
	
	#Identify which state we're in and run appropriate code
	match state:
		IDLE:
			#move velocity towards zero and seek player
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			
		WANDER:
			pass
		
		CHASE:
			#Link player variable
			var player = playerDetectionZone.player
			#If player is within radius
			if player != null:
				#the direction is the difference in the 2 positions
				var direction = (player.global_position - global_position).normalized()
				#Set velocity towards the player
				velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
			else:
				#Switch to IDLE when we lose sight of player
				state = IDLE
	
	#Flip to face the correct way
	sprite.flip_h = velocity.x < 0
	#Move and remember new vector
	velocity = move_and_slide(velocity)

func seek_player():
	#If we can see the player, change state to CHASE
	if playerDetectionZone.can_see_player():
		state = CHASE

	#area = the area that entered
func _on_Hurtbox_area_entered(area):
	#Lower the health
	stats.health -= area.damage
	#Set knockback by direction and multiplier
	knockback = area.knockback_vector * 100
	hurtbox.create_hit_effect()


func _on_Stats_no_health():
	queue_free()
	#Make instance of scene
	var enemyDeathEffect = EnemyDeathEffect.instance()
	#Add scene to the world scene
	get_parent().add_child(enemyDeathEffect)
	#Set the position
	enemyDeathEffect.global_position = global_position
