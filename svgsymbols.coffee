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
            selector = '#'+key
            break unless elem = @.querySelector(selector)
            if isTextOverride(elem)
                elem.querySelector('tspan').textContent = value
            else if isImageOverride(elem)
                setFillImage(@, elem, value)
            
    _updateWidth: () ->
        @.querySelector('svg').setAttribute 'width', @.width
        
    _updateHeight: () ->
        @.querySelector('svg').setAttribute 'height', @.height

# TODO: perhaps check for locked state
isTextOverride = (elem)->
    elem.tagName == 'text'

# TODO: ignore gradient fills
isImageOverride = (elem)->
    elem.tagName == 'rect' && !!elem.attributes['fill']

fetchAsDataURL = (url)->
  fetch(url)
  .then((response)-> response.blob())
  .then (blob) => new Promise (resolve, reject) ->
    reader = new FileReader()
    reader.onloadend = ()-> resolve(reader.result)
    reader.onerror = reject
    reader.readAsDataURL(blob)

setFillImage = (doc, elem, url)->
    patternId = elem.attributes['fill'].value.replace(/^url\(/,'').replace(/\)$/,'')
    imageId = doc.querySelector(patternId + ' use').attributes['xlink:href'].value
    image = doc.querySelector(imageId)
    fetchAsDataURL(url).then (dataUrl) =>
        image.attributes['xlink:href'].value = dataUrl
