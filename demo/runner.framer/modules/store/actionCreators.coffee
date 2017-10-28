{
	reset,
	setSliderValue
} = require "defs/actionTypes"

exports.reset = ->
	type: reset

exports.setSliderValue = (value) ->
	type: setSliderValue
	payload:
		value: value