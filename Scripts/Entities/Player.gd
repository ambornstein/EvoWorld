extends Human
class_name Player

var Fireball = preload("res://Scenes/Entities/Fireball.tscn")

@onready var interact_radius = $Reach
@onready var inventory_ui = $Camera2D/InventoryGUI

var reachable_resource

func _input(event):
	
	if event is InputEventMouseMotion and not animation.is_playing() and event.relative.length() > 5:
		if equipped_weapon:
			set_weapon_starting_pos()
			update_animation_position(_attack_orientation)
			
func _process(delta):
	_attack_orientation = get_global_mouse_position()-weapon.global_position
	super._process(delta)
	#print($Weapon/HitBox.monitorable)
	if Input.is_action_just_pressed("click") and not inventory_ui.visible and equipped_weapon:
		super.attack()
	#if Input.is_action_just_pressed("click"):
		#print(get_global_mouse_position())
		#var vec = position.direction_to(get_global_mouse_position())
		#_shoot(vec)
	if Input.is_action_just_pressed("interact"):
		if reachable_resource:
			reachable_resource.open()
			inventory_ui.show()
			
func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
	move_and_slide()
		
func _shoot(direction: Vector2):
	var fire = Fireball.instantiate()
	add_child(fire)
	fire.fire(direction)

###signals

func _on_reach_body_entered(body):
	if body.name == "Chest":
		inventory_ui.on_container_update(body.inventory)
		inventory_ui.set_container_inventory_data(body.inventory)
		reachable_resource = body

func _on_reach_body_exited(body):
	if reachable_resource == body:
		body.close()
		inventory_ui.on_container_update(null)
		reachable_resource = null
