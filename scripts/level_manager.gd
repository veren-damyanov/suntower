extends Node

const LEVELS = ['tutorial', 'level1']

var current_idx: int = 0
var current_level


func _ready() -> void:
    var level = load('res://scenes/levels/%s.tscn' % LEVELS[current_idx])
    self.current_level = level.instantiate()
    self.add_child(self.current_level)


func _input(event: InputEvent) -> void:
    if event.is_action_pressed('pause'):
        self.toggle_pause()

func toggle_pause() -> void:
    var paused = self.get_tree().paused
    self.get_tree().paused = !paused
    $PauseCanvas/PauseMenu.visible = !paused
    $PauseCanvas/PauseTint.visible = !paused

func _on_resume_pressed() -> void:
    self.toggle_pause()

func _on_exit_pressed() -> void :
    self.get_tree().paused = false
    self.get_tree().change_scene_to_file('res://scenes/main_menu.tscn')
