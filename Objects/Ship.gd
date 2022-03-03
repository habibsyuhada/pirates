extends KinematicBody

export (int) var accel = 2
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
	print(translation)

func get_input():
	rotation_dir = 0
	velocity = Vector3()
	if Input.is_action_pressed("ui_right"):
		rotation_dir -= 1
	if Input.is_action_pressed("ui_left"):
		rotation_dir += 1
	if Input.is_action_just_released("ui_down"):
		#velocity = Vector2(-speed, 0).rotated(rotation)
		speed -= accel
		if speed < 0:
			speed = 0
	if Input.is_action_just_released("ui_up"):
		#velocity = Vector2(speed, 0).rotated(rotation)
		speed += accel 
		if speed > max_speed:
			speed = max_speed
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
