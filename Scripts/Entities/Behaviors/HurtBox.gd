extends Area2D
class_name HurtBox

@export var health_bar: HealthComponent

#Settings to receive damage from layer 2
#func _init(): 
	#collision_layer = 0
	#collision_mask = 2
	
func _on_area_entered(hitbox:Area2D):
	health_bar.take_damage(5)

func set_collision(collision_params: CollisionData):
	$Collision.shape = collision_params.collision_shape
	$Collision.position = collision_params.collision_transform
