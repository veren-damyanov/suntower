extends AnimatedSprite2D

const FLOOR_TILES = [Vector2i(0, 0)]

var lit = false
@onready var tilemap = $"../TileMap"
@onready var pushables = $"../Pushables"


func _collect_occluder_objects() -> Array[Vector2i]:
    return [Vector2i(0, 0)]

func _input(event: InputEvent) -> void:
    #if !event.is_pressed:
        #return
    if event.is_action_pressed("left"):
        self.move(-1, 0)
        return
    if event.is_action_pressed("right"):
        self.move(1, 0)
        return
    if event.is_action_pressed("up"):
        self.move(0, -1)
        return
    if event.is_action_pressed("down"):
        self.move(0, 1)
        return

func _move_pushable(object: Sprite2D, dx: int, dy: int) -> bool:
    var object_pos = self.tilemap.local_to_map(object.get_position())
    var push_to = Vector2(object_pos.x + dx, object_pos.y + dy)
    var tile_id = self.tilemap.get_cell_atlas_coords(0, push_to)
    if tile_id in FLOOR_TILES:
        self.update_visual(object, push_to)
        self.tilemap.update_occluders()
        return true
    return false


func move(dx: int, dy: int) -> void:
    var current_pos = self.tilemap.local_to_map(self.position)
    var move_to = Vector2i(current_pos.x + dx, current_pos.y + dy)
    var tile_id = self.tilemap.get_cell_atlas_coords(0, move_to)
    if tile_id in FLOOR_TILES:
        for object in self.pushables.get_pushables():
            var object_pos = self.tilemap.local_to_map(object.get_position())
            if object_pos != move_to:
                continue
            if self._move_pushable(object, dx, dy):
                self._move_player(move_to)
            return
        self._move_player(move_to)

func _move_player(new_position):
    self.update_visual(self, new_position)
    if self.tilemap.is_object_lit(self):
        if lit:
            self.death()
        else:
            self.lit = true
    else:
        self.lit = false

func update_visual(object: Node2D, new_position: Vector2i) -> void:
    object.set_position(self.tilemap.map_to_local(new_position))

func death():
    self.get_tree().paused = true
    print('DEATH')
