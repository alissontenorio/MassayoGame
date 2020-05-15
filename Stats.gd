extends Node2D

export(int) var maxHealth = 1
onready var health = maxHealth setget sethealth

signal no_health

func sethealth(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
