extends Control

signal max_speed_slider_updated(slider_value)
signal update_rotaion_by_analog(force, pos)
signal change_status_analog(status)

func _on_VSlider_value_changed(value):
	emit_signal("max_speed_slider_updated", value)

func _on_AnalogController_analogChange(force, pos):
	emit_signal("update_rotaion_by_analog", force, pos)


func _on_AnalogController_analogRelease():
	emit_signal("change_status_analog", false)


func _on_AnalogController_analogPressed():
	emit_signal("change_status_analog", true)
