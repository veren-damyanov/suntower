extends TileMap

const WINDOW_TILES = [Vector2i(1, 2)]
const OCCLUDER_TILES = [Vector2i(2, 1)]

var lights = Array()
var occluders = Array()
@onready var pushables = $"../Pushables"


func _ready():
    self._create_occluders()
    self.update_occluders()

func is_object_lit(candidate: Node2D) -> bool:
    var verdict = false
    var candidate_pos = self.local_to_map(candidate.get_position())
    for light in self.lights:
        if light.x == candidate_pos.x and light.y < candidate_pos.y:
            verdict = true
    for occluder in self.occluders:
        var occluder_pos = self.local_to_map(occluder.get_position())
        if occluder_pos.x == candidate_pos.x and occluder_pos.y < candidate_pos.y:
            verdict = false
    for occluder in self.pushables.get_pushables():
        var occluder_pos = self.local_to_map(occluder.get_position())
        if occluder_pos.x == candidate_pos.x and occluder_pos.y < candidate_pos.y:
            verdict = false
    return verdict

func _create_occluders() -> void:
    var occluder_scene = load("res://scenes/occluder.tscn")
    for tile_pos in self.get_used_cells(0):
        var atlas_coords = self.get_cell_atlas_coords(0, tile_pos)
        if atlas_coords in WINDOW_TILES:
            self.lights.append(tile_pos)
        if atlas_coords in OCCLUDER_TILES:
            var instance = occluder_scene.instantiate()
            instance.set_position(self.map_to_local(tile_pos))
            self.add_child(instance)
            self.occluders.append(instance)

func update_occluders() -> void:
    for occluder in self.occluders:
        occluder.visible = self.is_object_lit(occluder)
    for occluder in self.pushables.get_pushables():
        occluder.get_children()[0].visible = self.is_object_lit(occluder)
