## Basic weapon that shoulds a simple bullet, targets one mob, and instantly
## damages it.
#ANCHOR:class_name
class_name SimpleCannon_2 extends Weapon_2
#END:class_name

var _target: Mob_2 = null

@onready var _marker_2d: Marker2D = %Marker2D


func _physics_process(_delta: float) -> void:
	if _target == null:
		_target = _find_closest_target()

	if _target == null:
		return

	_rotate_toward_target(_target)


func _attack() -> void:
	if _target == null or not is_instance_valid(_target):
		return
	var rocket: Node2D = preload("projectiles/simple_rocket.tscn").instantiate()
	get_tree().current_scene.add_child(rocket)
	rocket.global_transform = _marker_2d.global_transform
	rocket.damage = stats.damage
