class_name Collision_Visualizer3D extends MeshInstance3D

@export var collision : CollisionShape3D

func _ready():
	self.position = collision.position
	
	var mesh_shape: Mesh = null
	if collision.shape.is_class("SphereShape3D"):
		mesh_shape = SphereMesh.new()
		mesh_shape.radius = collision.shape.get_radius()
	elif collision.shape.is_class("BoxShape3D"):
		mesh_shape = BoxMesh.new()
		mesh_shape.size = collision.shape.get_size()
	elif collision.shape.is_class("CapsuleShape3D"):
		mesh_shape = CapsuleMesh.new()
		mesh_shape.set_height(collision.shape.get_height())
		mesh_shape.set_radius(collision.shape.get_radius())
	
	if mesh_shape != null:
		self.mesh = mesh_shape
