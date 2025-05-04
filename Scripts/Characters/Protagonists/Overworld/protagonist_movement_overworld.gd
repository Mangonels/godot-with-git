class_name ProtagonistMovement_Overworld extends EntityMovement_Overworld

@export var protagonist_data : ProtagonistGlobalData_RES
@export var main_camera : Camera3D
@export var ground_checker : ContactChecker_Groups

# True: Locks all movement,
# False: Unlocks all movement
@export var movement_locked : bool = false
# True: Makes the movement relative to the main camera,
# False: Makes the movement aligned with the world axis
@export var camera_relative : bool = true

# The horizontal movement direction vector.
# Should always be set normalized, and will usually be set by the ProtagonistLogic_Overworld
# Used for _physics_process movement calculation and applying
var horizontal_movement : Vector2 = Vector2.ZERO

func _physics_process(_delta):
	horizontal()

## Moves the protagonist horizontally according to direction, factoring
## in it's ground/air mobility and if it's relative to camera or world axis.
func horizontal():
	if horizontal_movement == Vector2.ZERO || movement_locked:
		return
	
	if camera_relative:
		# Extract relevant components (horizontal plane)
		var camera_right_2D = Vector2(main_camera.basis.x.normalized().x, main_camera.basis.z.normalized().x)
		var camera_forward_2D = Vector2(main_camera.basis.x.normalized().z, main_camera.basis.z.normalized().z)

		# The 2 angles work as horizontal movement coordinates
		horizontal_movement = Vector2(
			camera_right_2D.dot(horizontal_movement),
			camera_forward_2D.dot(horizontal_movement)
		)
	
	# The movement guaranteed velocity the protagonist must at least reach 
	# depending on grounded or airbourne status
	var target_velocity : Vector2
	# The rate at which the protagonist accelerates to target velocity, 
	# depends on the protagonist's base acceleration and deceleration while in 
	# grounded or airbourne status.
	# The protagonist is considered decelerating if the horizontal_movement
	# magnitude is low, while accelerating if high (threshold determined)
	var acceleration_rate : float
	if(ground_checker.is_contacting()):
		target_velocity = horizontal_movement * protagonist_data.ground_mobility
		acceleration_rate = protagonist_data.full_speed_rate_grounded
	else:
		target_velocity = horizontal_movement * protagonist_data.air_mobility
		acceleration_rate = protagonist_data.full_speed_rate_airbourne
	
	# How far are we from achieving target_velocity?
	var velocity_difference : Vector2 = target_velocity - Vector2(self.linear_velocity.x, self.linear_velocity.z)
	
	# A proportional (based on the difference from current speed to target speed) movement force is calculated:
	var mov_force_2d : Vector2 = velocity_difference * acceleration_rate
	var horiz_mov_force : Vector3 = Vector3(mov_force_2d.x, 0.0, mov_force_2d.y)
	
	# Apply the right precalculated amount of horizontal movement force
	# to the protagonist entity
	print("------")
	print("grounded: " + str(ground_checker.is_contacting()))
	print("current velocity: " + str(self.linear_velocity))
	print("target velocity: " + str(target_velocity))
	print("adding force to protagonist: " + str(horiz_mov_force))
	super.add_force_at_center(horiz_mov_force)

## Basically a "jump command", which may perform diferently depending on the 
## specific environment, examples:
## Jumping grounded, Jumping in water, Impulsing with wings 
func ascend():
	if movement_locked:
		return
	
	if ground_checker.is_contacting():
		super.add_force_at_center(Vector3.UP, protagonist_data.jump_strength)

func ascend_cut():
	if movement_locked:
		return

	if self.linear_velocity.y > 0 && !ground_checker.is_contacting():
		super.add_force_at_center(Vector3.DOWN, protagonist_data.jump_strength * protagonist_data.jump_cut_proportion)

func crouch():
	if movement_locked:
		return
