extends Node
class_name HealthComponent

@export var max_health := 10
var health

signal hurt

func take_damage(value: int): 
	health -= value
	clamp(health, 0, max_health)
	hurt.emit()
	print("%s: %d/%d" % [owner.name, health, max_health])
	
# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		owner.queue_free()
