extends Control
class_name CharacterSheet

@onready var level = $Panel/MarginContainer/VBoxContainer/Level
@onready var free_points = $Panel/MarginContainer/VBoxContainer/FreePoints
@onready var axe_ticks = $Panel/MarginContainer/VBoxContainer/AxeSkill
@onready var sword_ticks = $Panel/MarginContainer/VBoxContainer/SwordSkill
@onready var spear_ticks = $Panel/MarginContainer/VBoxContainer/SpearSkill

var player_stats
var original_stats

func _ready():
	var ticks = get_all_ticks(axe_ticks)
	for j: TextureButton in ticks:
		j.pressed.connect(increment_ticks.bind(axe_ticks))
	ticks = get_all_ticks(sword_ticks)
	for j: TextureButton in ticks:
		j.pressed.connect(increment_ticks.bind(sword_ticks))
	ticks = get_all_ticks(spear_ticks)
	for j: TextureButton in ticks:
		j.pressed.connect(increment_ticks.bind(spear_ticks))

func increment_ticks(container: FlowContainer):
	match container:
		axe_ticks:
			player_stats.axe_skill+=1
			allow_skill_pick(axe_ticks, player_stats.axe_skill)
		sword_ticks:
			player_stats.sword_skill+=1
			allow_skill_pick(sword_ticks, player_stats.sword_skill)
		spear_ticks:
			player_stats.spear_skill+=1
			allow_skill_pick(spear_ticks, player_stats.spear_skill)
	player_stats.points = player_stats.points-1
	free_points.text = "Free Points: " + str(player_stats.points)
	if player_stats.points <= 0:
		allow_skill_pick(axe_ticks,-1)
		allow_skill_pick(sword_ticks,-1)
		allow_skill_pick(spear_ticks,-1)

func load_stats(stats: CharacterData):
	player_stats = stats
	original_stats = stats.duplicate()
	level.text = "Level " + str(player_stats.level)
	free_points.text = "Free Points: " + str(player_stats.points)
	set_skill_tick(axe_ticks, player_stats.axe_skill)
	allow_skill_pick(axe_ticks, player_stats.axe_skill)
	set_skill_tick(sword_ticks, player_stats.sword_skill)
	allow_skill_pick(sword_ticks, player_stats.sword_skill)
	set_skill_tick(spear_ticks, player_stats.spear_skill)
	allow_skill_pick(spear_ticks, player_stats.spear_skill)

func set_skill_tick(container: FlowContainer, value: int):
	var ticks = get_all_ticks(container)
	for i in range(5):
		if i < value:
			ticks[i].button_pressed = true
		else:
			ticks[i].button_pressed = false

func allow_skill_pick(container: FlowContainer, value: int):
	var ticks = get_all_ticks(container)
	for i in range(5):
		if i == value:
			ticks[i].button_mask = MOUSE_BUTTON_MASK_LEFT
		else:
			ticks[i].button_mask = 0
	
func modify_stats():
	for skill: FlowContainer in [axe_ticks, sword_ticks, spear_ticks]:
		var all_ticks = get_all_ticks(skill)
		var stat_count = all_ticks.filter(func(tick): return tick.pressed).size()
		match [skill]: 
			axe_ticks:
				player_stats.axe_skill = stat_count
			sword_ticks:
				player_stats.sword_skill = stat_count
			spear_ticks:
				player_stats.spear_skill = stat_count
	player_stats.points = (player_stats.level-1) - (player_stats.axe_skill+player_stats.sword_skill+player_stats.spear_skill) 
	original_stats = player_stats.duplicate()

func reset():
	load_stats(original_stats)

func get_all_ticks(container: FlowContainer):
	var nodes = container.get_children()
	return nodes.filter(func(child): return child is TextureButton)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
