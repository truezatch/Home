#extends Node3D
#
#var player
#@export var sensitivity = 5
#
#func _ready():
#	player = get_tree().get_nodes_in_group("player")[0]
#
#func _process(delta):
#	global_position = player.global_position
#	#$SpringArm3D/Camera3D.look_at(player.get_node("LookAt").global_position)
#
#
#func _input(event):
#	if event is InputEventMouseMotion:
#		var temp_rotation = rotation.x - event.relative.y / 1000 * sensitivity
#		rotation.y -= event.relative.x / 1000 * sensitivity
#		temp_rotation = clamp(temp_rotation , 0 , 0.7)
#		rotation.x = temp_rotation
