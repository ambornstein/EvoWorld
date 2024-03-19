extends CharacterBody2D
class_name Player

var Fireball = preload("res://Scenes/Entities/Fireball.tscn")

@export var inventory: InventoryData
@export var equipment: InventoryData
@export var health: HealthComponent
@export var speed = 400  # speed in pixels/sec

@onready var sprite = $Character
@onready var interact_radius = $Reach
@onready var inventory_ui = $Camera2D/InventoryGUI

@onready var animation = $AnimationPlayer

@onready var helmet_sprite = $Helmet
@onready var chestplate_sprite = $Chestplate
@onready var weapon = $Weapon
@onready var slash_attack = animation.get_animation("slash_attack")
@onready var stab_attack = animation.get_animation("stab_attack")

var reachable_resource
var equipped_weapon: WeaponData

enum {LEFT, RIGHT}

var slash_half_arc: float = 0.35
var weapon_side = LEFT

func _input(event):
	var attack_direction = Vector2.UP.angle_to(get_global_mouse_position()-weapon.global_position)
	if event is InputEventMouseMotion and not animation.is_playing() and event.relative.length() > 5:
		if equipped_weapon:
			set_weapon_starting_pos()

func _ready():
	equip_armaments(equipment)
	health.hurt.connect(animation.queue.bind("hurt"))
	
	equipment.inventory_updated.connect(equip_armaments)

func set_weapon_starting_pos():
	var pos = Vector2(-6, 2)
	if weapon_side == LEFT:
		if equipped_weapon.weapon_class == "Axe":
			weapon.scale.x = -1
	elif weapon_side == RIGHT:
		pos = Vector2(7, 2)
		if equipped_weapon.weapon_class == "Axe":
			weapon.scale.x = 1
	weapon.position = pos
	animation.get_animation("RESET").track_set_key_value(0,0, pos)
	slash_attack.track_set_key_value(0,0,pos)
	slash_attack.track_set_key_value(0,3,pos)
	stab_attack.track_set_key_value(0,0,pos)
	stab_attack.track_set_key_value(0,2,pos)

#updating the frames of the animation for the active attack
func update_animation_position(point):
	var attack_direction = Vector2.UP.angle_to(point)
	var vec_shift = weapon.position.move_toward(point, 10)
	
	#slash active frames
	slash_attack.track_set_key_value(0, 1, vec_shift)
	slash_attack.track_set_key_value(0, 2, vec_shift)
	
	if weapon_side == LEFT:
		slash_attack.track_set_key_value(1, 1, attack_direction+slash_half_arc)
		slash_attack.track_set_key_value(1, 2, attack_direction-slash_half_arc)
	
	elif weapon_side == RIGHT:
		slash_attack.track_set_key_value(1, 1, attack_direction-slash_half_arc)
		slash_attack.track_set_key_value(1, 2, attack_direction+slash_half_arc)
	
	#stab active frames
	stab_attack.track_set_key_value(0, 1, vec_shift)
	
	stab_attack.track_set_key_value(1, 0, attack_direction)
	stab_attack.track_set_key_value(1, 1, attack_direction)
	stab_attack.track_set_key_value(1, 2, attack_direction)

func _process(delta):
	#print($Weapon/HitBox.monitorable)
	var rel_mouse_point = get_global_mouse_position()-weapon.global_position
	var attack_direction = Vector2.UP.angle_to(rel_mouse_point)
	
	if attack_direction < 0:
		weapon_side = LEFT
	else:
		weapon_side = RIGHT
	
	if not animation.current_animation and equipped_weapon:
		if weapon_side == LEFT:
			weapon.rotation = lerp(weapon.rotation, attack_direction+slash_half_arc, delta*5)
		elif weapon_side == RIGHT:
			weapon.rotation = lerp(weapon.rotation, attack_direction-slash_half_arc, delta*5)

	if Input.is_action_just_pressed("click") and not inventory_ui.visible and equipped_weapon:
		attack(rel_mouse_point)
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
	velocity = direction * speed
	move_and_slide()
		
func _shoot(direction: Vector2):
	var fire = Fireball.instantiate()
	add_child(fire)
	fire.fire(direction)

func attack(point: Vector2):
	weapon.get_node("HitBox").monitorable = true
	#print(anim.track_get_key_value(1, 1))
	
	#$Weapon.rotation_degrees = rad_to_deg(position.angle_to(direction))
	if equipped_weapon:
		if equipped_weapon.weapon_class in ["Axe", "Sword", "Mace", "Flail"]:
			slash_half_arc = 1
			update_animation_position(point)
			animation.queue("slash_attack")
		elif equipped_weapon.weapon_class in ["Spear", "Dagger", "Staff"]:
			slash_half_arc = 0
			update_animation_position(point)
			animation.queue("stab_attack")

###signals

func equip_armaments(inv: InventoryData):
	for i in 8:
		var equip_slot = inv.get_slot_data(i)
		if equip_slot:
			match i:
				equipment.EquipmentType.HELMET:
					helmet_sprite.texture = equip_slot.item_data.texture
				equipment.EquipmentType.WEAPON:
					weapon.texture = equip_slot.item_data.texture
					equipped_weapon = equip_slot.item_data

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

func _on_animation_player_animation_finished(anim_name):
	if anim_name in ["stab_attack", "slash_attack"]:
		weapon.get_node("HitBox").monitorable = false
		set_weapon_starting_pos()
