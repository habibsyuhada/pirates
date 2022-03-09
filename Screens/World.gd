extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var camera_distance = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera.global_transform.origin = lerp($Camera.global_transform.origin, Vector3($Ship.global_transform.origin.x+camera_distance, $Camera.global_transform.origin.y, $Ship.global_transform.origin.z), delta * 50)
