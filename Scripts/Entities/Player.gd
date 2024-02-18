extends CharacterBody2D

var Fireball = preload("res://Scenes/Entities/Fireball.tscn")

@export var inventory: InventoryData
@export var health: HealthComponent
@export var speed = 400  # speed in pixels/sec

@onready var sprite = $AnimatedSprite2D
@onready var interact_radius = $Reach

var reachable_resource
var harvestable

func _ready():
	health.connect("hurt", _damaged_animation)

func _process(delta):
	if get_closest_harvestable():
		harvestable = get_closest_harvestable().get_parent()
	#if Input.is_action_just_pressed("click"):
		#print(get_global_mouse_position())
		#var vec = position.direction_to(get_global_mouse_position())
		#_shoot(vec)
	#if Input.is_action_just_pressed("inventory"):
		#inventory._toggle()
		#inventory._clear_selection()
	if Input.is_action_just_pressed("interact"):
		if harvestable:
			harvestable.harvest()
			if harvestable.size == 1 and harvestable.has_method("exhaust"):
				harvestable.exhaust()
		if reachable_resource:
			reachable_resource.open()
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
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE

func _on_reach_body_entered(body):
	if body.name == "Chest":
		print(body)
		reachable_resource = body

func _on_reach_body_exited(body):
	reachable_resource = null
