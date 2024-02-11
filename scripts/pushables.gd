extends Node2D

var dynamic_occluders = Array()
@onready var tilemap = $"../TileMap"


func _ready() -> void:
    for child in self.get_children():
        self.dynamic_occluders.append(child)

func get_pushables() -> Array:
    return self.dynamic_occluders
