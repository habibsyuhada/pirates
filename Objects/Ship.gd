extends KinematicBody

export (float) var accel = 0.05
export (int) var accel_max_speed = 2
export (int) var current_max_speed = 0
export (int) var max_speed = 10
export (float) var rotation_speed = 0.75
export (PackedScene) var Bullet

var rotation_dir = 0
var velocity = Vector3()
var speed = 0

func _physics_process(delta):
	get_input()
	velocity = Vector3(0, 0, -speed).rotated(Vector3(0, 1, 0), rotation.y)
	rotation = Vector3(0, rotation.y + rotation_dir * rotation_speed * delta, 0)
	velocity = move_and_slide(velocity)
	global_transform.origin.y = 0
	$Particles.emitting = false
	$Particles.process_material.set("initial_velocity", speed/accel_max_speed)
	$Particles.process_material.set("linear_accel", -speed/accel_max_speed/2)
	$Particles.process_material.get("initial_velocity")
	if(abs(speed) > 1):
		$Particles.emitting = true

func get_input():
	rotation_dir = 0
	velocity = Vector3()
	if Input.is_action_pressed("ui_right"):
		rotation_dir -= 1
	if Input.is_action_pressed("ui_left"):
		rotation_dir += 1
	if Input.is_action_just_released("ui_down"):
		#velocity = Vector2(-speed, 0).rotated(rotation)
		current_max_speed -= accel_max_speed
		if current_max_speed < 0:
			current_max_speed = 0
	if Input.is_action_just_released("ui_up"):
		#velocity = Vector2(speed, 0).rotated(rotation)
		current_max_speed += accel_max_speed 
		if current_max_speed > max_speed:
			current_max_speed = max_speed
	
	if(speed < current_max_speed) :
		speed += accel
	if(speed > current_max_speed) :
		speed -= accel
	
	if Input.is_action_just_released("ui_select"):
		for body in $Area.get_overlapping_bodies():
			if(body.translation != translation):
				var b = Bullet.instance()
				owner.add_child(b)
				b.fire(global_transform.origin, body.translation)


func _on_Area_body_entered(body):
	pass # Replace with function body.


func _on_Area_body_exited(body):
	pass # Replace with function body.
