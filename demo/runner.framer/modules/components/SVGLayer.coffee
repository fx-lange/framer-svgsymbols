class SVGLayer extends Layer
	constructor: (options) ->
		rawSVG = Utils.domLoadDataSync(options.svgPath)
		rawSVG.search /viewBox/
		super _.defaults options,
			html: rawSVG

			
		if (!options.width? or !options.height?) and !options.size?
			SVG = @.querySelector 'svg'
			viewBox = SVG.getAttribute 'viewBox'
			values = viewBox.split " "
			@width = parseInt values[2]
			@height = parseInt values[3]
		else
			@._updateWidth()
			@._updateHeight()

	render: (options) ->
		keys = Object.keys options
		for key in keys
			value = options[key]
			selector = '#'+key+ ' tspan'
			@.querySelector(selector).textContent = value
					
	_updateWidth: () ->
		@.querySelector('svg').setAttribute 'width', @.width
			
	_updateHeight: () ->
		@.querySelector('svg').setAttribute 'height', @.height

exports.SVGLayer = SVGLayer