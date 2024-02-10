extends AnimatedSprite2D

const FLOOR_ID = Vector2i(0, 0)

@onready var tilemap = $"../TileMap"


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

func move(dx: int, dy: int) -> void:
    var rel_pos = tilemap.local_to_map(self.position)
    var move_to = Vector2i(rel_pos.x + dx, rel_pos.y + dy)
    var tile_id = tilemap.get_cell_atlas_coords(0, move_to)
    match tile_id:
        FLOOR_ID:
            self.update_visuals(move_to)

func update_visuals(new_position: Vector2i) -> void:
    self.set_position(new_position * 8)
