{ getState, dispatch, subscribe } = require "store/index"
{ reset } = require "store/actionCreators"
{ Slider} = require "components/slider"

slider = new Slider 'value-slider2'

# REGISTER CHANGE LISTENER TO STORE
lastState = undefined
subscribe ->
	newState = getState()
	# navigation.render newState, lastState
	slider.render
		value: Math.round(newState.slider.value)
	lastState = newState



# KICK OF THE PROTOTYPE
dispatch reset()

# prevent chrome on windows of emulating mouse events (and triggering twice)
document.addEventListener 'touchend', (event) -> event.preventDefault()


