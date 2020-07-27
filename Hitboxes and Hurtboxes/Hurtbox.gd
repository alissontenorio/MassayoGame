extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible 

onready var timer = $Timer
onready var collisionShape2D = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
		
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var hitEffect = HitEffect.instance()
	get_tree().current_scene.add_child(hitEffect)
	#hitEffect.global_position = get_node("CollisionShape2D").global_position
	hitEffect.global_position = collisionShape2D.global_position
	
func _on_Timer_timeout():
	self.invincible = false

func _on_Hurtbox_invincibility_started():
	collisionShape2D.set_deferred("disabled", true)
	  
func _on_Hurtbox_invincibility_ended():
	collisionShape2D.set_deferred("disabled", false)
