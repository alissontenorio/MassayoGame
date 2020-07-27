extends Node2D

const playerPreload = preload("res://Player/Player.tscn")
onready var playerLayDown = get_node("YSort/Player deitado")

# Called when the node enters the scene tree for the first time.
func _ready():
	var nodeLayDown = playerLayDown	
	
	var t = Timer.new()
	t.set_wait_time(5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	var player = playerPreload.instance()	
	
	nodeLayDown.rotation_degrees = 0
	player.transform = playerLayDown.transform
	
	playerLayDown.queue_free()
	
	get_node("YSort").add_child(player)
	get_node("YSort").move_child(player, 0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
