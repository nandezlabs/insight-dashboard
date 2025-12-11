#ANCHOR: L07_extends
extends Node
#END: L07_extends

#ANCHOR: L07_load_upgrades
const DAMAGE = preload("../turrets/upgrades/damage_upgrade.tres")
const FIRE_RATE = preload("../turrets/upgrades/fire_rate_upgrade.tres")
const RANGE = preload("../turrets/upgrades/range_upgrade.tres")
#END: L07_load_upgrades
const HOMING_TURRET = preload("../turrets/upgrades/homing_turret.tres")


func get_upgrades_for_weapon(weapon: Weapon_2, turret_level: int) -> TurretUpgrade_2:
	if weapon is SimpleCannon_2:
		if turret_level == 1:
			return DAMAGE
		elif turret_level == 2:
			return FIRE_RATE
		elif turret_level == 3:
			return RANGE
		elif turret_level == 4:
			return HOMING_TURRET
	return null
