extends Node

@onready var window : Window
var dialog : FileDialog
var previous_window_size : Vector2i
signal image_loaded(i : ImageTexture)

func _ready():
	window = get_window()
	window.set_max_size(DisplayServer.screen_get_size()) #maybe update this when screen changes
	#window.size_changed.connect(window.move_to_center)
	
func resize_window(new_size: Vector2):
	window.set_size(new_size)
	
func _process(_delta):
	if Input.is_action_just_pressed("Open File Dialog"):
		open_file_dialog()
	if Input.is_action_just_pressed("ui_down"):
		downsize_window()
	if Input.is_action_just_pressed("ui_up"):
		upsize_window()

func upsize_window():
	if window.size.y >= window.max_size.y:
		return
	var new_window_size = window.size * 2
	if new_window_size >= window.max_size:
		return #scale so that the aspect ratio is preserved but it fills the height
	previous_window_size = window.size
	resize_window(new_window_size)
	
func downsize_window():
	if window.size.y <= window.min_size.y:
		return
	var new_window_size = window.size / 2
	if new_window_size.y <= window.min_size.y:
		return
	resize_window(new_window_size)

func open_file_dialog():
	#print("file dialog")
	dialog = FileDialog.new()
	dialog.file_selected.connect(_file_selected)
	dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE) # select only one file at a time
	dialog.set_access(FileDialog.ACCESS_FILESYSTEM) # access whole filesystem
	dialog.set_flag(Window.FLAG_POPUP, true)
	dialog.set_transient(true)
	dialog.set_use_native_dialog(true)
	dialog.reset_size()
	dialog.add_filter("*.png, *.jpg", "Images")
	window.add_child(dialog)
	dialog.show()
	dialog.grab_focus()
	#dialog.request_attention()

func _file_selected(file_path : String):
	#print("file picked")
	var image = Image.load_from_file(file_path)
	var image_texture = ImageTexture.create_from_image(image)
	set_window_min_size(image.get_size())
	image_loaded.emit(image_texture)
	dialog.queue_free()

func set_window_min_size(texture_size: Vector2i):
	window.set_min_size(texture_size)
	resize_window(window.get_min_size())

func _initialise_window():
	window.set_initial_position(Window.WINDOW_INITIAL_POSITION_ABSOLUTE) #so you can call move_to_center
	window.set_flag(Window.FLAG_ALWAYS_ON_TOP, true)
	window.set_flag(Window.FLAG_RESIZE_DISABLED, true)
	window.set_flag(Window.FLAG_BORDERLESS, true)
	window.set_content_scale_aspect(Window.CONTENT_SCALE_ASPECT_KEEP)
	window.set_content_scale_mode(Window.CONTENT_SCALE_MODE_VIEWPORT)
	window.set_content_scale_stretch(Window.CONTENT_SCALE_STRETCH_INTEGER)
	#window.set_flag(Window.FLAG_RESIZE_DISABLED, true)
	window.set_flag(Window.FLAG_TRANSPARENT, true)
	window.set_transparent_background(true)
