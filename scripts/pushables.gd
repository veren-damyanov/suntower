extends Node2D

var pushables: Array = Array()
@onready var tilemap = $"../TileMap"


func _ready() -> void:
    for child in self.get_children():
        self.pushables.append(child)
    self.tilemap.update_occluders()

func all() -> Array:
    return self.pushables
