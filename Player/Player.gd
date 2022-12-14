extends KinematicBody2D

#Constants
export var acceleration = 800
export var max_speed = 75
export var roll_speed = 1.3
export var friction = 1000

#Identify states
enum {
	MOVE,
	ROLL,
	ATTACK
}

#set loaded state to MOVE and create velocity and roll variable
var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

#Load variables for nodes when ready
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
	#animation tree's root:
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	stats.connect("no_health", self, "queue_free")
	#Activate animation tree
	animationTree.active = true

	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	#Identify which state we're in and run appropriate method
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	

func move_state(delta):
	#Create input vector for direction
	var input_vector = Vector2.ZERO
	#Get average movement value, works with analog
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left") 
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	#Normalized makes the vector's length 1
	input_vector = input_vector.normalized()
	
	#If we're moving
	if input_vector != Vector2.ZERO:
		#Set direction of roll and knockback to the direction we're facing
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		#Set blend positions for animation, to input vector (Both are directions)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		#Play run animation from animation tree, uses the blend position for the right animation direction
		animationState.travel("Run")
		#Set the velocity vector by where the player is going and how fast they're doing it
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		#Sets animation and velocity to idle if not moving
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	move()
	
	#If pressing roll button, switch state to ROLL
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	#If pressing attack button, switch state to ATTACK
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state(delta):
	velocity = roll_vector * max_speed * roll_speed
	animationState.travel("Roll")
	move()

func attack_state(delta):
	#Stop movement and play animation
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	#Move the player
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	velocity = velocity * 0.2
	state = MOVE

func attack_animation_finished():
	#Switch to MOVE state after finishing attack animation, is called directly from AnimationPlayer
	state = MOVE

func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
