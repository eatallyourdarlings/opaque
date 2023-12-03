extends Node2D

@export var texture : Texture2D
var sprite : Sprite2D

func _ready():
	sprite = Sprite2D.new()
	sprite.texture_changed.connect(_texture_changed)
	Opaque.image_loaded.connect(sprite.set_texture)
	
	if texture: #exists in inspector. maybe could preload it.
		Opaque.set_window_min_size(texture.get_image().get_size()) #TODO eugh
		sprite.set_texture(texture)
	add_child(sprite)

func _texture_changed():
	var size : Vector2 = texture.get_size()
	sprite.set_position(Vector2(0,0))
	#Opaque.resize_window(size)
	sprite.translate(size/2)
