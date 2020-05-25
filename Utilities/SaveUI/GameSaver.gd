extends Node2D

const SAVE_DIR = "user://saves/"
var SAVE_PATH =  SAVE_DIR + "save.json"

func _ready():
	pass
		
func save_game():
	
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var save_game = File.new()
	save_game.open(SAVE_PATH, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("save")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file
		save_game.store_line(to_json(node_data))
	save_game.close()
		
func load_game():
	
	var save_game = File.new()
	if not save_game.file_exists(SAVE_PATH):
		return # Error! We don't have a save to load.
	
#	var save_nodes = get_tree().get_nodes_in_group("save")
#	for i in save_nodes:
#		i.queue_free()

	save_game.open(SAVE_PATH, File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "introduction":
				Globals.set_intro(true)
			if i == "gag":
				Globals.set_gag(node_data["gag"])
				print(node_data["gag"])
			if i == "parent" or i == "pos_x" or i == "pos_y": #i == "filename" or
				continue
			new_object.set(i, node_data[i])
	save_game.close()
	
	pass
	
