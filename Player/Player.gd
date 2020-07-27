extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 120
export var FRICTION = 1000

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var stats = PlayerStats
export var invincible_time = 1.2
#var knockback = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var swordCollisionShape = $HitboxPivot/SwordHitbox/CollisionShape2D
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

onready var roll_vector = animationTree.get("parameters/Roll/blend_position")

func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
	swordCollisionShape.set_disabled(true)	

func _physics_process(delta):
	#knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	#knockback = move_and_slide(knockback)
	
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()		
	
func move_state(delta):
	var input_vector = get_input_axis()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		set_animation_tree(input_vector)
		set_animation_state("Run")
		velocity = apply_movement(velocity, input_vector, delta) 		
	else:
		set_animation_state("Idle")
		velocity = apply_friction(velocity, delta)
		
	move()
	
	if Input.is_action_just_pressed("roll"):
		#state = ROLL
		pass
		
	if Input.is_action_just_pressed("attack"):
		#state = ATTACK
		pass
		
func roll_state():
	velocity = move_and_slide(ROLL_SPEED * roll_vector)
	set_animation_state("Roll")	
		
func attack_state():
	velocity = Vector2.ZERO
	set_animation_state("Attack")
	
func move():
	velocity = move_and_slide(velocity)
	
func attack_animation_finished():
	state = MOVE
	
func roll_animation_finished():
	velocity = velocity * 0.6
	state = MOVE
		
func get_input_axis():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")		
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")		
	return input_vector.normalized()

# warning-ignore:shadowed_variable
func apply_movement(velocity, input_vector, delta):
	return velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	
# warning-ignore:shadowed_variable
func apply_friction(velocity, delta):
	return velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func set_animation_tree(input_vector):
	animationTree.set("parameters/Idle/blend_position", input_vector)
	animationTree.set("parameters/Run/blend_position", input_vector)
	animationTree.set("parameters/Attack/blend_position", input_vector)
	animationTree.set("parameters/Roll/blend_position", input_vector)

# warning-ignore:shadowed_variable
func set_animation_state(state):
	animationState.travel(state)

func _on_Hurtbox_area_entered(area):
	#if !hurtbox.invincible:
	PlayerStats.health -= area.damage
	hurtbox.start_invincibility(invincible_time)
	hurtbox.create_hit_effect()

	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)
	#knockback = area.knockback_vector * area.knockback_force	
	
func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
