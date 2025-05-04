## Entities are objects that can move through physics in the game
class_name EntityMovement_Overworld extends RigidBody3D

func add_force_at_center(direction : Vector3, magnitude : float = 1.0):
	apply_central_force(direction * magnitude)
