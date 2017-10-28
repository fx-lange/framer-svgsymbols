{ combineReducers } = require "redux"
{ reset } = require "defs/actionTypes"
{ slider } = require "store/slider"

appReducer = combineReducers(
	slider: slider
)

rootReducer = (state, action) ->
	if action.type == reset
		return appReducer undefined, action
	appReducer state, action

exports.rootReducer = rootReducer
