extends Area2D

export(bool) var show_hit = true

const HitEffect = preload("res://Effects/HitEffect.tscn")

func _ready():
	self.connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area):
	if(show_hit):
		var hitEffect = HitEffect.instance()
		get_tree().current_scene.add_child(hitEffect)
		hitEffect.global_position = get_node("CollisionShape2D").global_position
