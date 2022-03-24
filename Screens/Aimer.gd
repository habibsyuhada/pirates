extends Area

onready var ship = get_node("/root/Game/World/Ship")
onready var shoot_analog = get_node("/root/Game/HUD/Shoot_Analog")
var target = Vector2.ZERO

func _ready():
	visible = false
	get_node("/root/Game/HUD").connect("status_shoot_analog", self, "_on_status_shoot_analog")
	get_node("/root/Game/HUD").connect("value_shoot_analog", self, "_on_value_shoot_analog")

func _process(delta):
	global_transform.origin.x = ship.global_transform.origin.x + target.y
	global_transform.origin.z = ship.global_transform.origin.z + -target.x
	#$Sprite.modulate = Color(1, 0, 0)
	
func _on_status_shoot_analog(status):
	visible = status
	if status == false && !shoot_analog.disable:
		ship.shoot_cannon(Vector3(global_transform.origin.x, 0, global_transform.origin.z))

func _on_value_shoot_analog(force, pos):
	target = pos
