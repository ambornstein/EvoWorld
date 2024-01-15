extends Area2D
class_name HurtBox

@export var health_bar: HealthComponent

#Settings to receive damage from layer 2
#func _init(): 
	#collision_layer = 0
	#collision_mask = 2
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_entered(hitbox:Area2D):
	health_bar.take_damage(5)
	

