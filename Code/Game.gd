# Game state
extends Node

export(NodePath) var combat_screen
export(NodePath) var movement_screen

const PLAYER_WIN = "res://dialogue/dialogue_data/player_won.json"
const PLAYER_LOSE = "res://dialogue/dialogue_data/player_lose.json"

func _ready():
	movement_screen = get_node(movement_screen)
	combat_screen = get_node(combat_screen)
	combat_screen.connect("combat_finished",self, "_on_combat_finished")
	for n in $Movement/Grid.get_children():
		if not n.type == n.CellType.ACTOR:
			continue
		if not n.has_node("DialoguePlayer"):
			continue
		n.get_node("DialoguePlayer").connect("dialogue_finished", self,
			"_on_opponent_dialogue_finished", [n])
	remove_child(combat_screen)
	
func start_combat(combat_actors):
	remove_child($Movement)
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	add_child(combat_screen)
	combat_screen.show()
	combat_screen.initialize(combat_actors)
	$AnimationPlayer.play_backwards("fade")

# warning-ignore:unused_argument
func _on_combat_finished(winner, _loser):
	remove_child(combat_screen)
	$AnimationPlayer.play_backwards("fade")
	add_child(movement_screen)
	var dialogue = load("res://dialogue/DialoguePlayer.tscn").instance()
	if winner.name == "Player":
		dialogue.dialogue_file = PLAYER_WIN
	else:
		dialogue.dialogue_file = PLAYER_LOSE
	yield($AnimationPlayer, "animation_finished")
	var player = $Movement/Grid/Player
	movement_screen.get_node("DialogueUI").show_dialogue(player, dialogue)
	combat_screen.clear_combat()
	yield(dialogue, "dialogue_finished")
	dialogue.queue_free()
	
func _on_opponent_dialogue_finished(opponent):
	if opponent.lost:
		return
	var player = $Movement/Grid/Player
	var combatants = [player.combat_actor, opponent.combat_actor]
	start_combat(combatants)
