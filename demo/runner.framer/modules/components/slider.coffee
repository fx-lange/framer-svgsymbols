{ SVGSymbol } = require "components/svgsymbols"
{ dispatch } = require "store/index"
{ setSliderValue } = require "store/actionCreators"

class Slider extends SVGSymbol
	constructor: (name, options) ->
		super name, options

		@minValue = 0
		@maxValue = 100
		@isDragging = false
		@.querySelector('#knob').addEventListener('drag', -> console.log 'drag')
		# @.onTap (value) ->
		# 	if value.target.id == 'track'
		# 		trackX = @.querySelector('#track').x.baseVal.value
		# 		groupX = @.querySelector('#Group').transform.baseVal[0].matrix.e
		# 		console.log 'group x', groupX
		# 		console.log @.querySelector('#track')
		# 		trackWidth = @.querySelector('#track').width.baseVal.value
		# 		tapX = value.startX
		# 		console.log 'onTap', value

		# 		console.log 'trackX', @.querySelector('#track'), trackX
		# 		mappedValue = Utils.modulate tapX, [groupX + trackX, groupX + trackX+trackWidth], [@minValue, @maxValue]
		# 		dispatch setSliderValue(mappedValue)
		
		@.on Events.MouseDown, (e) ->
			# if e.path[0].id == 'track' //works only in chrome
			if e.srcElement.id == 'track'
				@isDragging = true

		@.on Events.MouseMove, (e) =>
			if @isDragging
				tapX = e.point.x
					
				trackX = @.querySelector('#track').x.baseVal.value
				# works only in chrome
				# groupX = @.querySelector('#Group').transform.baseVal[0].matrix.e
				groupX = @.querySelector('#Group').transform.baseVal.getItem(0).matrix.e
				trackWidth = @.querySelector('#track').width.baseVal.value

				mappedValue = Utils.modulate tapX, [groupX + trackX, groupX + trackX+trackWidth], [@minValue, @maxValue], true
				dispatch setSliderValue(mappedValue)

		@.on Events.MouseUp, (e) ->
			@isDragging = false
	
	render: (options) ->
		super options

		value = options.value
		trackX = @.querySelector('#track').x.baseVal.value
		trackWidth = @.querySelector('#track').width.baseVal.value

		mappedValue = Utils.modulate value, [@minValue, @maxValue], [trackX, trackX + trackWidth], true
		newValue = mappedValue - trackX

		@.querySelector('#knob').setAttribute('transform', 'translate('+newValue+',0)')



exports.Slider = Slider