class exports.SVGSymbol extends Layer
    constructor: (name, options={}) ->
        path = 'svgsymbols/'+name+'.svgsymbol'
        rawSVG = Utils.domLoadDataSync(path)
        rawSVG.search /viewBox/
        super _.defaults options,
            html: rawSVG
            name: name
            backgroundColor: 'transparent'
        
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
