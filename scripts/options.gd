extends CenterContainer


func _ready():
    $VerticalContainer/Back.grab_focus()

func _on_back_pressed():
    get_tree().change_scene_to_file('res://scenes/main_menu.tscn')
