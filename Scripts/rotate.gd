extends Node

# Rotate the camera rig

func _process(delta):
	self.rotation_degrees += Vector3(0, 10 * delta, 0)
