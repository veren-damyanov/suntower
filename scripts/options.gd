extends MarginContainer


func _ready():
    $VerticalContainer/Horizontal/Settings/Back.grab_focus()

func _on_back_pressed():
    get_tree().change_scene_to_file('res://scenes/main_menu.tscn')

func _on_toggle_toggled(toggled_on):
    var mode = DisplayServer.WINDOW_MODE_MAXIMIZED
    if toggled_on:
        mode = DisplayServer.WINDOW_MODE_FULLSCREEN
    DisplayServer.window_set_mode(mode)
