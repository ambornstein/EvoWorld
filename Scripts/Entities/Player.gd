extends CharacterBody2D

var Fireball = preload("res://Scenes/Entities/Fireball.tscn")

@export var inventory: InventoryData
@export var health: HealthComponent
@export var speed = 400  # speed in pixels/sec

@onready var sprite = $Character
@onready var interact_radius = $Reach
@onready var inventory_ui = $Camera2D/InventoryGUI

@onready var animation = $AnimationPlayer

var reachable_resource
var harvestable

func _ready():
	health.hurt.connect(_damaged_animation)

func _process(delta):
	if Input.is_action_just_pressed("click") and not inventory_ui.visible:
		attack(get_global_mouse_position()-global_position)
	if get_closest_harvestable():
		harvestable = get_closest_harvestable().get_parent()
	#if Input.is_action_just_pressed("click"):
		#print(get_global_mouse_position())
		#var vec = position.direction_to(get_global_mouse_position())
		#_shoot(vec)
	if Input.is_action_just_pressed("interact"):
		if harvestable:
			harvestable.harvest()
			if harvestable.size == 1 and harvestable.has_method("exhaust"):
				harvestable.exhaust()
		if reachable_resource:
			reachable_resource.open()
			inventory_ui.show()
	#if Input.is_action_just_pressed("space"):
		##print(get_closest_harvestable())
		#if get_closest_harvestable():
			#var harvestable: Structure = get_closest_harvestable().get_parent()
			#harvestable.harvest()

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
		
func _shoot(direction: Vector2):
	var fire = Fireball.instantiate()
	add_child(fire)
	fire.fire(direction)

func attack(point: Vector2):
	var anim = animation.get_animation("attack") as Animation
	#print(anim.track_get_key_value(1, 1))

	var attack_direction = Vector2.UP.angle_to(point)
	var vec_shift = sprite.position.move_toward(point, 20)
	anim.track_set_key_value(0, 1, vec_shift)
	anim.track_set_key_value(1, 1, attack_direction)
	
	#$Weapon.rotation_degrees = rad_to_deg(position.angle_to(direction))
	if animation.current_animation != "attack":
		animation.queue("attack")
	
func get_closest_harvestable() -> Area2D:
	var areas = interact_radius.get_overlapping_areas()
	var closest
	for a in areas:
		if a.name == "HarvestRange":
			if closest == null or global_position.distance_to(a.global_position) < global_position.distance_to(closest.global_position):
				closest = a
	return closest

###signals
	
func _damaged_animation():
	if animation.is_playing():
		animation.queue("hurt")
	else:
		animation.queue("hurt")

func _on_reach_body_entered(body):
	if body.name == "Chest":
		inventory_ui.on_container_update(body.inventory)
		reachable_resource = body
	elif body is Forest or body is Boulder:
		harvestable = body

func _on_reach_body_exited(body):
	if reachable_resource == body:
		body.close()
		inventory_ui.on_container_update(null)
		reachable_resource = null
	elif harvestable == body:
		harvestable = null
