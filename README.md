# ZCAnimatedLabel
UILabel-like view with easy to extend appear/disappear animation

# Features
* Rich text support (with NSAttributedString)
* Group aniamtion by character/word/line
* Customizable animation start delay for each text block
* Great performance, only changed area is redrawn
* Optional layer-based implementation
* 3D/Geometry transform support (layer based only)
* iOS 5+ capatibility

# Demo

* Default
* Fall
* Duang/Spring
* Flyin
* Focus
* Shapeshift
* Reveal
* Thrown
* Transparency
* Spin
* Dash
* More to come


# How to use
`ZCAnimatedLabel` is available via CocoaPods. If you don't need all the effect subclasses, simply drag `ZCAnimatedLabel.(h|m)`, `ZCCoreTextLayout.(h|m)` and `ZCEasingUtil.(h|m)` into your project and start customizing


# Subclassing
`ZCAnimatedLabel` has two modes: non-layer based and layer based. In the first mode, `ZCAnimatedLabel` is a flat `UIView`, everything and every stage of animation is drawn using Core Graphics, you can customize redraw area for your animation for better performance. Override the following methods:

* `- (void) textBlockAttributesInit: (ZCTextBlock *) textBlock;`
* `- (void) appearStateDrawingForRect: (CGRect) rect textBlock: (ZCTextBlock *) textBlock;`
* `- (void) disappearStateDrawingForRect: (CGRect) rect textBlock: (ZCTextBlock *) textBlock;`
* `- (CGRect) redrawAreaForRect: (CGRect) rect textBlock: (ZCTextBlock *) textBlock;`

Second option is layer based, where each text block is a simple `CALayer`, 3D tranform is possible in this mode by setting layer's `transform` property, if redraw area is bigger and not too much text blocks, this can achive a performance gain. Set `self.layerBased` to `YES` and override these methods for customization:

* `- (void) textBlockAttributesInit: (ZCTextBlock *) textBlock;`
* `- (void) appearStateLayerChangesForTextBlock: (ZCTextBlock *) textBlock;`
* `- (void) disappearLayerStateChangesForTextBlock: (ZCTextBlock *) textBlock;`


# Todo
* Flatten CALayer no longer animating into a single backing store and reuse CALayer for animating layers. (Better performance for layerBased implementation)
* More Effects, possily glyph related ones
* Use core animation emmiter



# Thanks to

* `LTMorhpingLabel` for heavy inspiration
* `AGGeometryKit` for arbitrary shape 3D transform


