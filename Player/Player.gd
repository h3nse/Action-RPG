extends KinematicBody2D

#Constants
const acceleration = 800
const max_speed = 100
const friction = 1000

#Identify states
enum {
	MOVE,
	ROLL,
	ATTACK
}


#set loaded state to MOVE and create velocity variable
var state = MOVE
var velocity = Vector2.ZERO

#Load variables for animation controll nodes when ready
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
	#animation tree's root:
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

func _process(delta):
	#Identify which state we're in and run appropriate method
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
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
		#Set blend positions for animation, to input vector (Both are directions)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		#Play run animation from animation tree, uses the blend position for the right animation direction
		animationState.travel("Run")
		#Set the velocity vector by where the player is going and how fast they're doing it
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		#Sets animation and velocity to idle if not moving
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	#Move the player
	velocity = move_and_slide(velocity)
	
	#If pressing attack button, switch state to ATTACK
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state(delta):
	#Stop movement and play animation
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attack_animation_finished():
	#Switch to MOVE state after finishing attack animation, is called directly from AnimationPlayer
	state = MOVE
