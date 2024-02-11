extends Node2D

var extendables: Array = Array()
@onready var tilemap = $"../TileMap"


func _ready() -> void:
    print('extendables.ready()')
    for child in self.get_children():
        self.extendables.append(child)
    self.tilemap.update_occluders()

func all() -> Array:
    return self.extendables

func trigger(channel: int) -> void:
    for child in self.get_children():
        if child.channel == channel:
            child.trigger()
