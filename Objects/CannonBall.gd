extends Area

export var lateral_speed = 15 

var vector_target = Vector3.ZERO
var vector_origin = Vector3.ZERO
var origin_distance = 0
var velocity = Vector3.ZERO
var divergence:Vector3 = Vector3(3,0,3)

var g:float = 0
var fire_velocity:Vector3 = Vector3()
var max_height:float = 3.0

export (PackedScene) var WaterFoam = preload("res://Objects/WaterFoam.tscn")


func _ready():
	set_physics_process( false )

func fire(origin:Vector3, nTarget:Vector3):
	vector_target = nTarget + Vector3(rand_range(-divergence.x,divergence.x),rand_range(-divergence.y,divergence.y),rand_range(-divergence.z,divergence.z))
	calc_g_and_velocity(origin, vector_target)
	translation = origin
	set_physics_process( true )

func _physics_process(delta):
	translate(fire_velocity * delta)
	fire_velocity.y -= g * delta
	if translation.y < vector_target.y:
		var asd = WaterFoam.instance()
		get_tree().get_root().add_child(asd)
		print(get_tree().get_root().name)
		asd.global_transform.origin = global_transform.origin
		asd.emitting = true
		queue_free()

func calc_g_and_velocity(proj_pos:Vector3, target_pos:Vector3):
	var diff:Vector3 = target_pos - proj_pos
	var diffXZ:Vector3 = Vector3(diff.x, 0, diff.z)
	var lateralDist:float = diffXZ.length()

	if (lateralDist == 0):
		return false

	var time:float = lateralDist / lateral_speed

	fire_velocity = diffXZ.normalized() * lateral_speed

	var a:float = proj_pos.y;    # initial
	var b:float = max_height;    # peak
	var c:float = target_pos.y;   # final

	g = -4*(a - 2*b + c) / (time* time)
	fire_velocity.y = -(3*a - 4*b + c) / time

	return true
