extends MarginContainer

@onready var animation = $Transition/AnimationPlayer
var animation_callback = '_start_game'


func _ready():
    $VerticalContainer/Buttons/Start.grab_focus()

func _on_start_pressed() -> void:
    self.animation_callback = '_start_game'
    self.animation.play('fade_out')

func _start_game() -> void:
    get_tree().change_scene_to_file('res://scenes/level_manager.tscn')


func _on_level_select_pressed():
    pass # Replace with function body.

func _on_options_pressed() -> void:
    get_tree().change_scene_to_file('res://scenes/options.tscn')

func _on_exit_pressed() -> void:
    self.get_tree().quit()

func _on_animation_finished() -> void:
    call(self.animation_callback)
