{ setSliderValue } = require "defs/actionTypes"

initialState =
	value: 0

exports.slider = (state = initialState, action) ->
	switch action.type
		when setSliderValue
			return Object.assign {}, state,
				value: action.payload.value

	return state