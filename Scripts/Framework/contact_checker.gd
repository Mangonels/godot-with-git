## Can check to see if we're contacting with other physical bodies
class_name ContactChecker extends Area3D

# Reminder: call in _physics_process
func get_contacts() -> int:
	return get_overlapping_bodies().size()

# Reminder: call in _physics_process
func is_contacting() -> bool:
	print(get_contacts())
	return get_contacts() > 0
