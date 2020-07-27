extends KinematicBody2D

enum {
	IDLE,
	WANDER
}

export var ACCELERATION = 300
export var FRICTION = 200
export var MAX_SPEED = 20
export var WANDER_TARGET_RANGE = 4

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

var state = WANDER
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

onready var sprite = $AnimatedSprite
onready var wanderController = $WanderController
onready var softCollision = $SoftCollision
onready var waypoints = get_parent().get_node("MotoqueiroWaypoints")
var waypointIndex = 0
var waypoint = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	#state = pick_random_state([IDLE, WANDER])
	waypoint = waypoints.get_child(waypointIndex)
	waypointIndex = (waypointIndex + 1) % waypoints.get_child_count()

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER:
			#if wanderController.get_time_left() == 0:
			#	update_wander()
			#accelerate_towards_point(wanderController.target_position, delta)
			#if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
			#	update_wander()
			accelerate_towards_point(waypoint.position, delta)
			if global_position.distance_to(waypoint.position) <= WANDER_TARGET_RANGE:
				update_wander()
				
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)
	
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	if state == WANDER:
		waypoint = waypoints.get_child(waypointIndex)
		waypointIndex = (waypointIndex + 1) % waypoints.get_child_count()
		print(waypointIndex)
	wanderController.start_wander_timer(rand_range(1,3))
	
func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x > 0
	
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front() 	
