extends Control

#00cfff world sky color

signal max_speed_slider_updated(slider_value)
signal update_rotaion_by_analog(force, pos)
signal change_status_analog(status)

signal status_shoot_analog(status)
signal value_shoot_analog(force, pos)

func _ready():
	$Area_Speed_Slider.connect("max_speed_slider_updated", self, "_on_VSlider_value_changed")
	
func _on_VSlider_value_changed(value):
	emit_signal("max_speed_slider_updated", value)

func _on_Move_Analog_analogPressed():
	emit_signal("change_status_analog", true)

func _on_Move_Analog_analogChange(force, pos):
	emit_signal("update_rotaion_by_analog", force, pos)

func _on_Move_Analog_analogRelease():
	emit_signal("change_status_analog", false)


func _on_Shoot_Analog_analogPressed():
	emit_signal("status_shoot_analog", true)


func _on_Shoot_Analog_analogChange(force, pos):
	var range_shoot = 15
	emit_signal("value_shoot_analog", force, pos * range_shoot)


func _on_Shoot_Analog_analogRelease():
	emit_signal("status_shoot_analog", false)
