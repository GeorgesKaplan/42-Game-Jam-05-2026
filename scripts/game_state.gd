extends Node

## Emitted when the game transitions into the active gameplay state.
signal on_game_started()

## All states handled by this game flow state machine.
enum State {
	NONE, ## Initial placeholder before the first real state is assigned.
	MENU, ## The player is in the main menu or another non-gameplay screen.
	GAME, ## Core gameplay is currently running.
	PAUSE, ## Gameplay is temporarily suspended.
	GAME_OVER ## The run has ended and results / retry flow can be shown.
	}

## Tracks the currently active state.
var current: State = State.NONE

## Maps each state to the function that should run after entering it.
var _on_enter: Dictionary = {
	State.MENU: Callable(enter_menu),
	State.GAME: Callable(enter_game),
	State.PAUSE: Callable(enter_pause),
	State.GAME_OVER: Callable(enter_game_over)
}

## Maps each state to the function that should run before leaving it.
var _on_exit: Dictionary = {
	State.MENU: Callable(exit_menu),
	State.GAME: Callable(exit_game),
	State.PAUSE: Callable(exit_pause),
	State.GAME_OVER: Callable(exit_game_over)
}

## Changes the active state, running exit logic for the old state first,
## then enter logic for the new one.
func set_state(new_state: State) -> void:
	if (new_state == current):
		return
	if (_on_exit.has(current)):
		@warning_ignore("unsafe_method_access")
		_on_exit[current].call()
	current = new_state
	if (_on_enter.has(current)):
		@warning_ignore("unsafe_method_access")
		_on_enter[current].call()

## Runs whenever the menu state becomes active.
func enter_menu() -> void:
	pass

## Runs right before leaving the menu state.
func exit_menu() -> void:
	pass

## Starts gameplay-specific logic when entering the game state.
func enter_game() -> void:
	on_game_started.emit()
	print("Game Started")

## Runs right before leaving the active gameplay state.
func exit_game() -> void:
	pass

## Runs whenever the game is paused.
func enter_pause() -> void:
	pass

## Runs when leaving the pause state and resuming another flow.
func exit_pause() -> void:
	pass

## Runs when the game-over state becomes active.
func enter_game_over() -> void:
	pass

## Runs right before leaving the game-over state.
func exit_game_over() -> void:
	pass
