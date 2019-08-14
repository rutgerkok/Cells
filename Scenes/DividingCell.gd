extends RigidBody2D

signal divide

var min_area = 300
var area = min_area
var max_area


func _ready():
    max_area = 1400 + randf() * 400
    
    # Make sure each cell has their own shape instance
    var existing_shape: Shape2D = $CollisionShape2D.get_shape()
    $CollisionShape2D.set_shape(existing_shape.duplicate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    area += delta * 300
    if area > max_area:
        # Divide
        emit_signal("divide", self.position)
        self.queue_free()

    var radius = sqrt(area)

    $CollisionShape2D.get_shape().set_radius(radius)
    var desired_width = radius * 2
    var sprite : Sprite = $Sprite
    var texture_size = sprite.texture.get_size()
    sprite.scale = Vector2(desired_width / texture_size.x, desired_width / texture_size.y)
    


func _on_VisibilityNotifier2D_screen_exited():
    self.queue_free()
