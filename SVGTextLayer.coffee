class exports.SVGTextLayer extends Layer
    constructor: (options) ->
        rawSVG = Utils.domLoadDataSync(options.svgPath)
        rawSVG.search /viewBox/
        super _.defaults options,
            html: rawSVG
            width: 400
            height: 200

        SVG = @.querySelector 'svg'
        viewBox = SVG.getAttribute 'viewBox'
        values = viewBox.split " "
        
        if options.width?
            @width = parseInt values[2]
        if options.height?
            @height = parseInt values[3]

    render: (options) ->
        keys = Object.keys options
        for key in keys
            value = options[key]
            selector = '#'+key+ ' tspan'
            @.querySelector(selector).textContent = value