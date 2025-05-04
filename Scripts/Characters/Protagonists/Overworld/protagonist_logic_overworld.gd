class_name ProtagonistLogic_Overworld extends Node

var _grounded_previous_frame = false

@export var protagonist_body : ProtagonistMovement_Overworld
@export var protagonist_feet : RigidBody3D
@export var ground_checker : ContactChecker_Groups

var last_jump_input_start : float = 0.0

func _physics_process(_delta):
	_on_grounded_ungrounded_checks()
	
	# Movement command check
	var move_direction = Vector2.ZERO
	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_direction.y = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	
	protagonist_body.horizontal_movement = move_direction.normalized()
	
	# Jump command check
	if Input.is_action_just_pressed("jump"):
		last_jump_input_start = 0.0
		protagonist_body.ascend()

	if Input.is_action_just_released("jump"):
		protagonist_body.ascend_cut()

func _process(_delta):
	last_jump_input_start += _delta

func _on_grounded_ungrounded_checks():
	# Remove feet friction when detaching from ground, 
	# return friction on landing (could optionally be done gradually)
	# FIXES: Velocity halt on landing
	
	# Just detached from ground check:
	if(_grounded_previous_frame and not ground_checker.is_contacting()):
		protagonist_feet.physics_material_override.set_friction(0.0)
	# Just landed check:
	elif(not _grounded_previous_frame and ground_checker.is_contacting()):
		protagonist_feet.physics_material_override.set_friction(0.7)
		
	_grounded_previous_frame = ground_checker.is_contacting()
