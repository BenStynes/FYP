extends Node2D

class_name CombatArena

const BattlerNode = preload("Res://src/combat/battlers/Battler.tscn")

onready var turn_queue: TurnQueue = $TurnQueue
onready var interface = $CombatInterface

var active: bool = false
var party: Array = []
var initial_formation: Formation

signal battle_ends

signal battle_completed
signal victory
signal game_over


func initialize(formation: Formation, party: Array):
	initial_formation = formation
	ready_field(formation, party)
	
	
	var battlers = turn_queue,get_battlers()
	for battler in batlers:
		battler.iniialize()
		
		interface.initalize(self,turn_queue,battlers)
		turn_queue.initalize()
		
		
func battle_start():
	yield(play_intro(),"completed")
	play_turn()
	
func play_intro():
	for battler in turn_queue.get_party()
		battler.appear()
	yield(get_tree(),create_timer(0.5), "timeout")
	for battler in turn_queue.get_monsters()
		battler.appear()	
	yield(get_tree().create_timer(0.5), "timeout")
	
func ready_field(formation: Formation, party_members: Array):
	for enemy_template in formation.get_children():
		var enemy: Battler = enemy_template.duplicate()
		turn_queue.add_child(enemy)
		enemy.stats.reset()
		
	var party_spawm_positions = $SpawnPositions
	for i in len(party_members):
		
		var party_member = party_members[i]
		var spawn_point = party_spawn_positions.get_child(i)
		var battler: Battler = party_member.get_battler_copy()
		battler.position = spawn_point.position
		battler.name = party_member.name
		battler.set_meta("party_member", party_member)
		turn_queue.add_child(battler)
		self.party.append(battler)
		battler.ai.set("interface",interface)
func battle_end():
	emit_signal("battle_ends")
	active = false
	var active_battler = get_active_battler()
	active_battler.selected = false
	var player_won = active_battler.party_memeber
	if playet_won:
		emit_signal("victory")
		emit_signal("battle_completed")
	else:
		emit_signal("game_over")
		
func play_turn():
	vat battler: Battler = get_active_battler()
	var targets: Array = get_targets()
	var action: CombatAction
	
	while not battler.is_able_to_play():
		turn_queue.skip_turn()
		battler = get_active_battler()
	
	battler.selected = true
	var opponenets: Array = get_targets()
	id not opponents:
		battle_end()
		return
	
	action = yield(battler.ai.choose_action(battler, opponents), "completed")
	targets = yield(battler.ai.choose_target(battler, action, opponents), "completed")
	battler.selected = false

	if targets != []:
		yield(turn_queue.play_turn(action, targets), "completed")
	if active:
		play_turn()
		
func get_active_battler() -> Battler:
	return turn_queue.active_battler


func get_targets() -> Array:
	if get_active_battler().party_member:
		return turn_queue.get_monsters()
	else:
		return turn_queue.get_party()
