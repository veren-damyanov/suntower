extends Node2D

const LEVELS = ['tutorial', 'level1']

var current_idx: int = 0
var current_level


func _ready():
    var level = load('res://scenes/levels/%s.tscn' % LEVELS[current_idx])
    self.current_level = level.instantiate()
    self.add_child(self.current_level)
