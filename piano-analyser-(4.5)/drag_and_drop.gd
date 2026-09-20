extends Control
var song;
func _ready() -> void:
	get_window().files_dropped.connect(onFilesDropped)
	pass
	
func onFilesDropped(files: Array):
	#wow look a player droped in a thing? what is the thing who knows but its super cool
	for i in files:
		print("New file detected")
		if i.ends_with(".mp3") || i.ends_with(".wav"):
			# woah it was a music file all along
			var audioPlayer = get_node("../OnTimePlayer")
			var label = get_node("../Label")
			#wow its a song now lest feed it to the music player
			song = loadMusic(i)
			audioPlayer.stream = song
			audioPlayer.play()
			label.text= ""
			#wow now its playing things and we don't need to tell the player to insert files anymore
pass

#Takes in where the file you just dropped in is located, grabs it chews it up and spits out food for the audio player
func loadMusic(path):
	var file:FileAccess  = FileAccess.open(path,FileAccess.READ)
	if file and file.is_open():
		var sound
		if path.ends_with(".mp3"):
			sound  = AudioStreamMP3.new()
		if path.ends_with(".wav"):
			sound = AudioStreamWAV.load_from_file(path)
		sound.data = file.get_buffer(file.get_length())
		return sound
	else:
		print("ERROR! WHAT DID YOU DO??? WHAT IS WRONG WITH YOUR FILE????")
		pass
	

	
