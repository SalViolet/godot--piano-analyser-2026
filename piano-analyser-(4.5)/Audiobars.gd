# used a tutorial for this part of the code

extends PanelContainer

#how many bars, this one can be changed min is like 8 or smth
const BAR_COUNT: int = 88
#from where to where are we itterating
const FREQ_MAX: float = 4186
const MIN_DB: int = 100
# its a bird its a plane its  the master bus effect
var spectrum: AudioEffectSpectrumAnalyzerInstance
#What should the height be, what could the height be, why should the heights be...the bells toll heights, and the toll for be
var heights: Array[Height] = []
#this will be chaged in the on resized func, its basically the width of the bars in the corrner box
var bar_width: float = 0.0 


func _ready() -> void:
	#Takes the spectrum analyser from the master bus
	spectrum = AudioServer.get_bus_effect_instance(0, 1)
	for i: int in BAR_COUNT:
		heights.append(Height.new())
		_on_resized()
	
# first it reads the freq magnitudes and then draws them into the bar thing in the corrner
func _process(_delta: float) -> void:
	_update_spectrum_data()
	queue_redraw()

# redraws the bars at new heights constantly
func _draw() -> void:
	for i: int in BAR_COUNT:
		var l_color: Color = Color.from_hsv((BAR_COUNT*0.6+i*0.5)/ BAR_COUNT, 0.5, 0.6)
		var l_rect: Rect2 = Rect2(
			i*bar_width,
			size.y - heights[i].actual,
			bar_width-2,
			heights[i].actual
		)
		draw_rect(l_rect, l_color)
pass
	

#gets freq and magnitude
func _update_spectrum_data() -> void:
	var l_prev_hz: float = 0.0
	for i: int in BAR_COUNT:
		# gets freq lvl were analysiung and gets magnitude
		var l_hz: float = (i+1)*FREQ_MAX/BAR_COUNT
		var l_magnitude: float = spectrum.get_magnitude_for_frequency_range(l_prev_hz, l_hz).length()
		#make data fit in box even if its really loud
		var l_energy: float = clampf((MIN_DB + linear_to_db(l_magnitude)) /MIN_DB,0,1)
		var l_height: float = l_energy*size.y*10.00
		if l_height > heights[i].high:
			heights[i].high=l_height
		else:
			heights[i].high = lerp(heights[i].high, l_height, 0.1)
		
		if l_height < heights[i].low:
			heights[i].low = lerp(heights[i].low, l_height, 0.1)
		heights[i].actual = lerp(heights[i].low,heights[i].high,0.1 )
		l_prev_hz=l_hz	
	pass
	# boom! now we have bars
func _on_resized() -> void:
	bar_width = size.x/BAR_COUNT
	
#it can be between like 2 vals so now we have a bunch of stuff we calculate 
class Height:
	var high: float
	var low: float
	var actual: float
