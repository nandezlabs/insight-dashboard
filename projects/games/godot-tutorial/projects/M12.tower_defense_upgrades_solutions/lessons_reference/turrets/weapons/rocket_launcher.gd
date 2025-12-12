class_name RocketLauncher extends Weapon_2

var _target: Mob_2 = null

@onready var marker_2d: Marker2D = %Marker2D
@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D


func _physics_process(_delta: float) -> void:
	if _target == null:
		_target = _find_closest_target()

	if _target == null:
		return

	#ANCHOR: L09_rotate_toward_target
	_rotate_toward_target(_target)
	#END: L09_rotate_toward_target


func _attack() -> void:
	#ANCHOR: L08_spawn_rocket
	if _target == null:
		return

	var rocket: Area2D = preload("projectiles/homing_rocket.tscn").instantiate()
	get_tree().current_scene.add_child(rocket)
	rocket.global_transform = marker_2d.global_transform
	#END: L08_spawn_rocket

	#ANCHOR: L08_init_rocket
	rocket.target = _target
	rocket.damage = stats.damage
	rocket.set_initial_velocity()
	#END: L08_init_rocket

	#ANCHOR: L08_spawn_particles
	gpu_particles_2d.restart()
	#END: L08_spawn_particles
