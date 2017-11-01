class exports.SVGSymbol extends Layer
    constructor: (name, options={}) ->
        super _.defaults options,
            html: fetchSVGSymbol(name)
            name: name
            backgroundColor: 'transparent'
        @prefix = name+'-'+uuidv4()
        @rewriteSVGIds()
        if (!options.width? or !options.height?) and !options.size?
            viewBox = @.querySelector('svg').getAttribute 'viewBox'
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
            # looking for `svgsymbols:name` attributes
            selector = '[svgsymbols\\:name="'+key+'"]'
            break unless elem = @.querySelector(selector)
            if isTextOverride(elem)
                elem.querySelector('tspan').textContent = value
            else if isImageOverride(elem)
                setFillImage(@, elem, value)

    rewriteSVGIds: ()->
        @.querySelectorAll('[id]').forEach (elem)=>
            id = elem.getAttribute('id')
            prefixed = @prefix + '-' + id
            elem.setAttribute('id', prefixed)
            # XML namespaces in CSS selectors are tricky
            # https://stackoverflow.com/a/23047888
            sel = '[*|href="#'+id+'"]'
            links = @.querySelectorAll(sel)
            links.forEach (ref)-> ref.setAttribute('xlink:href', '#'+prefixed)
            linkable_attributes = ["fill", "filter", "mask", "stroke"]
            linkable_attributes.forEach (attr)=>
                sel = '['+attr+'="url(#'+id+')"]'
                @.querySelectorAll(sel).forEach (ref)->
                    ref.setAttribute(attr, 'url(#'+prefixed+')')

    _updateWidth: () ->
        @.querySelector('svg').setAttribute 'width', @.width
        
    _updateHeight: () ->
        @.querySelector('svg').setAttribute 'height', @.height

fetchSVGSymbol = (name)->
    path = 'svgsymbols/'+name+'.svgsymbol'
    Utils.domLoadDataSync(path)

# RFC1422-compliant Javascript UUID function. Generates a UUID from a random
# number (which means it might not be entirely unique, though it should be
# good enough for many uses). See http://stackoverflow.com/questions/105034
uuidv4 = ->
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
        r = Math.random() * 16 | 0
        v = if c is 'x' then r else (r & 0x3|0x8)
        v.toString(16)
    )

# TODO: perhaps check for locked state
isTextOverride = (elem)->
    elem.tagName == 'text'

# TODO: ignore gradient fills
isImageOverride = (elem)->
    elem.attributes['fill'] && elem.attributes['fill'].value.match(/^url\(/)

fetchAsDataURL = (url)->
  fetch(url)
  .then((response)-> response.blob())
  .then (blob) => new Promise (resolve, reject) ->
    reader = new FileReader()
    reader.onloadend = ()-> resolve(reader.result)
    reader.onerror = reject
    reader.readAsDataURL(blob)

setFillImage = (layer, elem, url)->
    patternId = elem.attributes['fill'].value.replace(/^url\(/,'').replace(/\)$/,'')
    imageId = layer.querySelector(patternId + ' use').attributes['xlink:href'].value
    image = layer.querySelector(imageId)
    fetchAsDataURL(url).then (dataUrl) =>
        image.attributes['xlink:href'].value = dataUrl
