extends RigidBody3D

var flash

func _ready():
	flash = get_node()

func picked():
	print("Object Interacted")
	visible = not visible
	
