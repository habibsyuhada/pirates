extends Area2D

onready var area_shape = get_node("Area_Shape_Area_Speed_Slider")
onready var grabber = get_node("Grabber")
var isPressed = false

signal max_speed_slider_updated(slider_value)

func _input(event):
	if event is InputEventMouseMotion or event is InputEventMouseButton or event is InputEventScreenTouch or event is InputEventScreenDrag:
		if abs(event.position.x - area_shape.global_position.x) >= area_shape.shape.extents.x:
			return false
		elif abs(event.position.y - area_shape.global_position.y) >= area_shape.shape.extents.y:
			return false
			
		if event is InputEventMouseButton or event is InputEventScreenTouch :
			isPressed = event.pressed
		if isPressed :
			grabber.global_position.y = event.position.y
			var value_slider = ((area_shape.shape.extents.y - 1) - grabber.position.y) / 2
			emit_signal("max_speed_slider_updated", value_slider)
