extends TileMap

const WINDOW_TILES = [Vector2i(0, 3), Vector2i(0, 4), Vector2i(0, 5),
                      Vector2i(1, 3), Vector2i(1, 4), Vector2i(1, 5),
                      Vector2i(2, 3), Vector2i(2, 4), Vector2i(2, 5),
                      Vector2i(3, 3), Vector2i(3, 4), Vector2i(3, 5)]
const OCCLUDER_TILES = [Vector2i(3, 2)]
const FLOOR_TILES = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0)]

var lights = Array()
var occluders = Array()
@onready var pushables = $"../Pushables"
@onready var extendables = $"../Extendables"


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
    for pushable in self.pushables.all():
        var pushable_pos = self.local_to_map(pushable.get_position())
        if pushable_pos.x == candidate_pos.x and pushable_pos.y < candidate_pos.y:
            verdict = false
    for extendable in self.extendables.all():
        if extendable.state == 0:
            continue
        var pushable_pos = self.local_to_map(extendable.get_position())
        if pushable_pos.x == candidate_pos.x and pushable_pos.y < candidate_pos.y:
            verdict = false
    return verdict

func is_tile_free(tile_pos: Vector2i):
    var tile_id = self.get_cell_atlas_coords(0, tile_pos)
    if tile_id not in FLOOR_TILES:
        return false
    for pushable in self.pushables.all():
        if self.local_to_map(pushable.get_position()) == tile_pos:
            return false
    for extendable in self.extendables.all():
        if extendable.state != 1:
            continue
        if self.local_to_map(extendable.get_position()) == tile_pos:
            return false
    return true

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
    for pushable in self.pushables.all():
        pushable.get_node('OccluderRoot').visible = self.is_object_lit(pushable)
    for extendable in self.extendables.all():
        if extendable.state == 1 and self.is_object_lit(extendable):
            extendable.get_node('OccluderRoot').visible = true
        else:
            extendable.get_node('OccluderRoot').visible = false
