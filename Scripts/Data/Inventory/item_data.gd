extends Resource
class_name ItemData

@export var name: String
@export_multiline var description: String
@export var stackable: bool = false
@export var texture: Texture
@export_enum("Helmet","Weapon","Chest","Shield","Leg","Left Ring","Boot","Right Ring","None") var equip_type: int = 8
