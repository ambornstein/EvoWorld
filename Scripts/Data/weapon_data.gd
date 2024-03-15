extends ItemData
class_name WeaponData

@export var damage: int
@export_enum("Axe", "Dagger", "Sword", "Staff", "Mace", "Flail", "Spear") var weapon_class
@export_flags("Wood:16", "Rock:32") var harvest_type
