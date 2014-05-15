![AGGeometryKit](/logo.png?raw=true "AGGeometryKit") 

Bridging [AGGeometryKit](https://github.com/hfossli/AGGeometryKit) with [POP](https://github.com/facebook/pop) for amazing dynamics and animations.

See [this interesting video](https://vimeo.com/93206523) about animation principles by Cento Lodigiani. If you like what you see and want to mimic step #1 and #5 - then this kit is here to help you.


### Installation

New-school: Use the cocoa pod named `AGGeometryKit+POP`.  
Old-school: Grab the files found in `Source`.




## Demo

[![Demo video](/video-aggeometrykit-pop.png)](https://vimeo.com/95383807)   
[See the video on vimeo ](https://vimeo.com/95383807)

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
