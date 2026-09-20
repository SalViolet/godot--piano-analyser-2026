extends ColorRect

#litterally just gets told quick turn red and turns red for a second, the life of a key is a simple one.
func pressKey():
	var orgColor = self.color
	self.color = Color.DARK_RED
	await get_tree().create_timer(1.0).timeout 
	self.color = orgColor
	
