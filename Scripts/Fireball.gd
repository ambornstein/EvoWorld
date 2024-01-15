extends Area2D
class_name Fireball

var speed = 750
var direction
#Settings to deal damage to layer 2
#func _init():
	#collision_layer = 2
	#collision_mask = 0
	
# Called when the node enters the scene tree for the first time.
func _ready():
	direction = Vector2(0,0)

func fire(projectile_direction):
	direction = projectile_direction.normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
