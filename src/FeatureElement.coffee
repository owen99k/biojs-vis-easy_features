Utils = require "./utils"
Eventhandler = require "biojs-events"

module.exports =
#
# displays features
#
class FeatureElement

  constructor: (divName,features,featureWidth,maxLen,leftOffset) ->
    # dirty hack
    Eventhandler.mixin FeatureElement.prototype

    featureSpan = document.getElementById divName

    # default values
    featureWidth = 10 unless featureWidth?
    fontSize = 18 unless fontSize?
    maxLen = undefined unless maxLen?
    leftOffset = 0 unless leftOffset?

    el = @create featureSpan,features,featureWidth,fontSize,maxLen,leftOffset

  create: (featureSpan,features,featureWidth,fontSize,maxLen,leftOffset) ->

    if features? and features?.length > 0

      unless maxLen?
        maxLen = features.reduce( (a,b) -> Math.max a,b.end, 0)


      features = FeatureElement.sortFeatureArray features

      rowsNeeded = FeatureElement.getMinRows features, maxLen
      # an arr for each row
      rows = (document.createDocumentFragment() for x in [1..rowsNeeded])

      # loop over all annotations
      for feature in features
        rect = @drawRectangle feature,featureWidth,fontSize
        # look for an row to put in
        for row in rows

          rowLength = row.childNodes.length
          if rowLength is 0 or row.childNodes[rowLength - 1]?.xEnd < feature.xStart
            if rowLength > 0
              rect.style.marginLeft = "#{featureWidth * (feature.xStart - 1 - row.childNodes[rowLength - 1].xEnd)}px"
            else if rowLength is 0
              rect.style.marginLeft = "#{featureWidth * (feature.xStart)}px"

            row.appendChild rect
            break

      # post all annotations
      residueGroup = document.createDocumentFragment()
      for row in rows
        rowSpan = document.createElement "span"
        rowSpan.className = "biojs-easy-feature-row"
        rowSpan.style.display = "block"

        # do something more elegant
        if leftOffset?
          labelOffset = document.createElement "span"
          labelOffset.style.width = "#{leftOffset}px"
          rowSpan.appendChild labelOffset

        rowSpan.appendChild row
        residueGroup.appendChild rowSpan

      featureSpan.className = "biojs-easy-feature"
      featureSpan.style.display = "block"
      featureSpan.appendChild residueGroup

    # TODO: what should we return here?
    return featureSpan

  # draws a single feature
  drawRectangle: (feature, width, fontSize) ->
    residueSpan = document.createElement "span"
    if feature.text?.length > 0
      residueSpan.textContent = feature.text
    else
      residueSpan.textContent = "#"

    # bgcolor
    bgColor = Utils.hex2rgb feature.fillColor
    residueSpan.style.backgroundColor = Utils.rgba bgColor, feature.fillOpacity
    residueSpan.bgColor = bgColor

    #border
    borderColor = feature.borderColor
    residueSpan.style.border =  "#{feature.borderSize}px solid #{borderColor}"

    # other
    residueSpan.style.width = "#{width * (feature.xEnd - feature.xStart + 1)}px"
    residueSpan.style.fontSize = "#{fontSize}px"

    # save end property
    residueSpan.xEnd = feature.xEnd

    # style
    residueSpan.style.display = "inline-block"

    # events
    residueSpan.addEventListener "mouseover", (event) =>
      opacity = 0.8
      div = event.target
      div.style.backgroundColor = Utils.rgba div.bgColor, opacity
      @trigger "mouseover", feature

    residueSpan.addEventListener "mouseout", =>
      opacity = 0.5
      div = event.target
      div.style.backgroundColor = Utils.rgba div.bgColor, opacity
      @trigger "mouseover", feature

    residueSpan.addEventListener "click", =>
      @trigger "click", feature

    return residueSpan

  # sort the feature array after the start property
  @sortFeatureArray: (arr) ->

    compare = (a,b) ->
      if a.xStart < b.xStart
        return -1
      else if a.xStart > b.xStart
        return 1
      return

    arr.sort compare

  # calculates how many rows are needed
  @getMinRows: (features, seqLen) ->

    rows = (0 for x in [1..seqLen])

    for feature in features
      for x in [feature.xStart..feature.xEnd] by 1
        rows[x]++

    max = 0
    for x in [0..seqLen - 1] by 1
      max = rows[x] if rows[x] > max

    return max
