extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 1000

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)
	
func move_state(delta):
	var input_vector = get_input_axis()
	
	if input_vector != Vector2.ZERO:
		set_animation_tree(input_vector)
		set_animation_state("Run")
		velocity = apply_movement(velocity, input_vector, delta)
	else:
		set_animation_state("Idle")
		velocity = apply_friction(velocity, delta)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state(delta):
	velocity = Vector2.ZERO
	set_animation_state("Attack")
	
func attack_animation_finished():
	state = MOVE

func roll_state(delta):
	pass
	
func get_input_axis():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")		
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")		
	return input_vector.normalized()

func apply_movement(velocity, input_vector, delta):
	return velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	
func apply_friction(velocity, delta):
	return velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func set_animation_tree(input_vector):
	animationTree.set("parameters/Idle/blend_position", input_vector)
	animationTree.set("parameters/Run/blend_position", input_vector)
	animationTree.set("parameters/Attack/blend_position", input_vector)

func set_animation_state(state):
	animationState.travel(state)
