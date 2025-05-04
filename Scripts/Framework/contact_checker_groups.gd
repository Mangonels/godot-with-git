## Can check to see if we're contacting with other physical bodies
## Will account for whitelist and blacklist of groups to consider or ignore
class_name ContactChecker_Groups extends Area3D

@export var is_blacklist : bool = false
@export var groups = PackedStringArray()

# Reminder: call this function in _physics_process
func get_contacts() -> int:
	var contact_count = 0
	var physic_nodes = get_overlapping_bodies();
	for i in physic_nodes.size():
		for j in groups.size():
			if is_blacklist:
				if not physic_nodes[i].is_in_group(groups[j]):
					contact_count += 1
			elif physic_nodes[i].is_in_group(groups[j]):
				contact_count += 1
	return contact_count

# Reminder: call this function in _physics_process
func is_contacting() -> bool:
	return get_contacts() > 0
