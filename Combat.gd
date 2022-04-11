extends Node


signal combat_finished(winner,loser)

func initilaize(combat_combatants):
	for combatant in combat_combatants:
		combatant = combatant.instance()
		if combatant is Combatant:
			$Combatants.add_combatant(combatant)
			combatant.get_node()
