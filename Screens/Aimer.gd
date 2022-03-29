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
	var deg_ship = Vector2(ship.get_node("FrontShip").global_transform.origin.x - ship.global_transform.origin.x, ship.get_node("FrontShip").global_transform.origin.z - ship.global_transform.origin.z)
	var deg_aim = Vector2(target.y, -target.x)
	print(rad2deg(deg_ship.angle_to(deg_aim)))
	$Sprite3D.modulate = Color(1, 0, 0)
	if abs(rad2deg(deg_ship.angle_to(deg_aim))) > 45 and abs(rad2deg(deg_ship.angle_to(deg_aim))) < 135 :
		$Sprite3D.modulate = Color(1, 1, 1)
	if status == false && !shoot_analog.disable && $Sprite3D.modulate == Color(1, 1, 1):
		ship.shoot_cannon(Vector3(global_transform.origin.x, 0, global_transform.origin.z))

func _on_value_shoot_analog(force, pos):
	target = pos
