extends Control
#numer of keys, for coding reasons this cannot be changed without breaking things, mostly because of the limit and piano key things
const BAR_COUNT: int = 88
#the script each of the piano key children are created get so they know to turn red for a second or two
var KeyScript = load("res://color_rect.gd")
#The thing the music is playing through
var OnTimePlayer:AudioStreamPlayer
#the slider at the bottom of the screen
var SensitiviySlider:float = 0.0
#the values of the freq at each moment
var freqVals: Array[float] =  []
#values taken from "node freq analysis", need to be manually put in to avoid loading lime laking 2 minutes since audio can only be done during runtime 
var limit: Array[float] = [0.0014306207886,0.0046716700308,0.01030628848821,0.02450497820973,0.00212677847594,0.00289331795648,0.00187618134078,0.0130673032254,0.02098186127841,0.00962463393807,0.00479982048273,0.01126625202596,0.04519210755825,0.00128768268041,0.02684917673469,0.01628872193396,0.00996745284647,0.01131601538509,0.01003737654537,0.00022094225278,0.00100531312637,0.03411482647061,0.00241791992448,0.00242854328826,0.00231746328063,0.00067892379593,0.01139761228114,0.00142866512761,0.00235121091828,0.00875694770366,0.00466408813372,0.00065878982423,0.00755116157234,0.00783894676715,0.00078990095062,0.00628469418734,0.00776811363176,0.0034709693864,0.00105925754178,0.00024061824661,0.00317997299135,0.0080949710682,0.00056708138436,0.0002482632699,0.00548674957827,0.00086400721921,0.00407415814698,0.00389559241012,0.0003343988792,0.00594159914181,0.00029495102353,0.00327172293328,0.00362334284,0.00039068935439,0.00204934249632,0.00086279248353,0.00010489280248,0.00232462375425,0.00035895043402,0.00188548711594,0.00601728120819,0.00219652662054,0.01084436755627,0.00159813836217,0.00079728086712,0.00227994006127,0.00159487954807,0.00248202192597,0.00196558469906,0.00391485029832,0.00429623527452,0.00368919712491,0.00050643179566,0.00221905903891,0.00033750012517,0.00153483671602,0.0002976906253,0.00054773723241,0.00118449120782,0.00030851041083,0.00110809749458,0.0001156775761,0.00067715585465,0.00034030410461,0.00041123735718,0.00199678563513,0.00022500514751,0.0001]
#the base freq for every note on piano
var PianoFreq: Array[float] = []
#number of notes played for that nifty little thing at the end
var noteCount:int = 0
# the thign from the master bus
var spectrum: AudioEffectSpectrumAnalyzerInstance
# I didn't really feel like learning the system for piano key naming so I jsut sort of coppied and pasted the keys here its much easier this way
var piano_keys: Array[String] = [
	"A0", "A#0", "B0", 
	"C1", "C#1", "D1", "D#1", "E1", "F1", "F#1", "G1", "G#1", "A1", "A#1", "B1",
	"C2", "C#2", "D2", "D#2", "E2", "F2", "F#2", "G2", "G#2", "A2", "A#2", "B2",
	"C3", "C#3", "D3", "D#3", "E3", "F3", "F#3", "G3", "G#3", "A3", "A#3", "B3",
	"C4", "C#4", "D4", "D#4", "E4", "F4", "F#4", "G4", "G#4", "A4", "A#4", "B4",
	"C5", "C#5", "D5", "D#5", "E5", "F5", "F#5", "G5", "G#5", "A5", "A#5", "B5",
	"C6", "C#6", "D6", "D#6", "E6", "F6", "F#6", "G6", "G#6", "A6", "A#6", "B6", 
	"C7", "C#7", "D7", "D#7", "E7", "F7", "F#7", "G7", "G#7", "A7", "A#7", "B7",
    "C8"
]

func _ready() -> void:
	PianoFreq.resize(BAR_COUNT)
	pianoFreq()
	spectrum = AudioServer.get_bus_effect_instance(0, 1)
	freqVals.resize(BAR_COUNT)
	OnTimePlayer = get_node("../OnTimePlayer")
	buildKeys()
# get all the base freq for each key with this handy little equasion I have! isnt it cool, isn't it nice when thin gs have equasions *looks at equal loudness curve*
func pianoFreq()-> void:
	for i: int in range(21,108):
		PianoFreq[i-21]=(2**((i-69.0)/12)*(440.0))
		pass
		
		
func _process(_delta: float) -> void:
		_update_spectrum_data()
		KeyColor()
		

#you know all those things we got earlier yeah lets get the magnitude
func _update_spectrum_data() -> void:
		for i: int in BAR_COUNT:
			var mag = spectrum.get_magnitude_for_frequency_range(PianoFreq[i], PianoFreq[i]+.1).length()
			freqVals[i] = mag
		pass
#wow we have magniudes, first decides weather the note is worthy by checking if anythings being played. then it finds the key baby created in the key baby making function below and tells the key baby its actully red now unless it is already red in which case it does nothing
# comments brought to you by 1AM violet :D
func KeyColor() -> void:
	if spectrum.get_magnitude_for_frequency_range((2**((21-69.0)/12)*(440.0)), (2**((88-69.0)/12)*(440.0))).length()>0.025:
		var i = freqVals.find(freqVals.max())
		if (freqVals[i])>=(limit[i]+SensitiviySlider):
			var playedKey = find_child("key " + str(i), false)
			if playedKey:
				if playedKey.color!=Color.DARK_RED:
					noteCount+=1
					print(piano_keys[i]," ",int(floor((OnTimePlayer.time)/60)),":",str(int(fmod((OnTimePlayer.time)/60,1.0)*100)))
					playedKey.pressKey()
pass

#makes a bunch of key babys (colored square children) to become the keys gives them the key script and sends them off on their marry way
func buildKeys() -> void:
	for i: int in BAR_COUNT:
		var babyKey: ColorRect = ColorRect.new()
		babyKey.color = Color.WHITE_SMOKE
		var KeyLoop:int= (i-4)%12
		if (KeyLoop==1)||(KeyLoop==3)||(KeyLoop==6)||(KeyLoop==8)||(KeyLoop==10)||(i==2):
			babyKey.size =  Vector2((size.x/float(BAR_COUNT)),size.y-(int(1)*30))
			babyKey.color = Color.BLACK
		else:
			babyKey.size =  Vector2((size.x/float(BAR_COUNT-36)),size.y-(int(0)*30))
			
		babyKey.position.x =  i*(size.x/float(BAR_COUNT))
		babyKey.position.y =  0
		babyKey.name = "key " + str(i)
		add_child(babyKey)
		babyKey.set_script(KeyScript)
		babyKey.owner = self
		pass

	

#oh woweee the songs done, resets the program and tells you what youve won
func _on_on_time_player_finished() -> void:
	print("song complete! notes: "+str(noteCount))
	var label = get_node("../Label")
	label.text= "Drop music anywhere to analyze"
	pass # Replace with function body.


func _on_sensitivity_slider_value_changed(value: float) -> void:
	SensitiviySlider = value
	pass # Replace with function body.


func _on_sensitivity_slider_drag_ended(value_changed: bool) -> void:
	if (value_changed):
		print("Sensitivity changed to ",SensitiviySlider)
	pass # Replace with function body.
