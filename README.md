![AGGeometryKit](/logo.png?raw=true "AGGeometryKit") 

Bridging [AGGeometryKit](https://github.com/hfossli/AGGeometryKit) with [POP](https://github.com/facebook/pop) for amazing dynamics and animations.


### Installation

New-school: Use the cocoa pod named `AGGeometryKit+POP`.  
Old-school: Grab the files found in `Source`.




## Demo

Tap to open in vimeo

[![Demo video](http://i.vimeocdn.com/video/475269317_600.jpg)](https://vimeo.com/95289118))

## Interface

Animate each corner independently using these new POPAnimatableProperty's.

    extern NSString * const kPOPLayerAGKQuadTopLeft;
    extern NSString * const kPOPLayerAGKQuadTopLeftX;
    extern NSString * const kPOPLayerAGKQuadTopLeftY;

    extern NSString * const kPOPLayerAGKQuadTopRight;
    extern NSString * const kPOPLayerAGKQuadTopRightX;
    extern NSString * const kPOPLayerAGKQuadTopRightY;

    extern NSString * const kPOPLayerAGKQuadBottomLeft;
    extern NSString * const kPOPLayerAGKQuadBottomLeftX;
    extern NSString * const kPOPLayerAGKQuadBottomLeftY;

    extern NSString * const kPOPLayerAGKQuadBottomRight;
    extern NSString * const kPOPLayerAGKQuadBottomRightX;
    extern NSString * const kPOPLayerAGKQuadBottomRightY;

    @interface POPAnimatableProperty (AGK_POP)

    + (instancetype)AGKPropertyWithName:(NSString *)aName;

    @end




## Keywords

Convex quadrilateral, simple quadrilateral, tangential, kite, rhombus, square, trapezium, trapezoid, parallelogram, bicentric, cyclic, POP, facebook, animation, dynamics, simulation




## Who's behind this?

Agens.no a company situated in Oslo, Norway with some help from some very clever stackoverflow.com guys.


[![Agens | Digital craftsmanship](http://static.agens.no/images/agens_logo_w_slogan_avenir_small.png)](http://agens.no/)
