extends Node

signal outcome_applied(outcome: Outcome)

func apply(outcome: Outcome, context: GameContext) -> void:
	outcome.resolve(context)
	outcome_applied.emit(outcome)

func apply_all(outcomes: Array[Outcome], context: GameContext) -> void:
	for outcome in outcomes:
		apply(outcome, context)
