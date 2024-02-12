extends MarginContainer


func _ready():
    $VerticalContainer/Buttons/Start.grab_focus()

func _on_start_pressed():
    get_tree().change_scene_to_file('res://scenes/level_manager.tscn')

func _on_level_select_pressed():
    pass # Replace with function body.

func _on_options_pressed():
    get_tree().change_scene_to_file('res://scenes/options.tscn')

func _on_exit_pressed():
    self.get_tree().quit()
