extends Area

onready var ship = get_node("/root/Game/World/Ship")

func _ready():
	visible = false
	get_node("/root/Game/HUD").connect("status_shoot_analog", self, "_on_status_shoot_analog")
	get_node("/root/Game/HUD").connect("value_shoot_analog", self, "_on_value_shoot_analog")
	
func _on_status_shoot_analog(status):
	visible = status
	if status == false :
		ship.shoot_cannon(Vector3(global_transform.origin.x, 0, global_transform.origin.z))

func _on_value_shoot_analog(force, pos):
	global_transform.origin.x = ship.global_transform.origin.x + pos.y
	global_transform.origin.z = ship.global_transform.origin.z + -pos.x
