extends Node3D


func _physics_process(delta):
	
	if Input.is_action_pressed("ui_accept"):
		position.x += 1
