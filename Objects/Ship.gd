extends KinematicBody

export (float) var accel = 0.05
export (int) var accel_max_speed = 2
export (int) var current_max_speed = 0
export (int) var max_speed = 10
export (float) var rotation_speed = 0.75
export (PackedScene) var Bullet
export (float) var range_shoot = 15

var rotation_dir = 0
var velocity = Vector3()
var speed = 0
var analog_steer = false
var target_dir_analog = 0

var last_debug

func _ready():
	get_node("/root/Game/HUD").connect("max_speed_slider_updated", self, "_on_max_speed_slider_updated")
	get_node("/root/Game/HUD").connect("update_rotaion_by_analog", self, "_on_update_rotaion_by_analog")
	get_node("/root/Game/HUD").connect("change_status_analog", self, "_on_change_status_analog")

func _physics_process(delta):
	get_input()
	
	if analog_steer :
		if abs(rotation.y - target_dir_analog) >= 1 :
			if rotation.y < target_dir_analog : rotation_dir += 1
			if rotation.y > target_dir_analog : rotation_dir -= 1
		else :
			if rotation.y < target_dir_analog : rotation_dir += abs(rotation.y - target_dir_analog)
			if rotation.y > target_dir_analog : rotation_dir -= abs(rotation.y - target_dir_analog)
		
	velocity = Vector3(0, 0, -speed).rotated(Vector3(0, 1, 0), rotation.y)
	rotation = Vector3(0, rotation.y + rotation_dir * rotation_speed * delta, 0)
	
	if rotation_dir != 0 :
		rotation_dir = 0
		
	velocity = move_and_slide(velocity)
	global_transform.origin.y = 0
	$Particles.emitting = false
	$Particles.process_material.set("initial_velocity", speed/accel_max_speed)
	$Particles.process_material.set("linear_accel", -speed/accel_max_speed/2)
	$Particles.process_material.get("initial_velocity")
	if(abs(speed) > 1):
		$Particles.emitting = true

func _on_max_speed_slider_updated(slider_value):
	current_max_speed = slider_value / 100 * max_speed
	if current_max_speed > max_speed:
		current_max_speed = max_speed

func _on_update_rotaion_by_analog(force, pos):
	var direction_analog = Vector2(pos.x, -pos.y).angle()

	var max_angle = PI * 2
	var difference = fmod(direction_analog - rotation.y, max_angle)
	difference = fmod(2 * difference, max_angle) - difference
	target_dir_analog = rotation.y + difference
	print(rad2deg(target_dir_analog))
	
func _on_change_status_analog(status):
	analog_steer = status

func get_input():
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

func shoot_cannon(target_position):
	for i in 8:
		var b = Bullet.instance()
		owner.add_child(b)
		b.fire(global_transform.origin, target_position)
