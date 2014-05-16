![# AGGeometryKit](/logo.png?raw=true "AGGeometryKit")

Quadrilaterals on CALayer (control each corner point individually), CGGeometry-functions, UIView/CALayer properties and other invaluable tools.



### Installation

New-school: Use the cocoa pod named `AGGeometryKit`.   
Old-school: Grab the files found in `Source`.



## Demo

[![Demo video](http://i.vimeocdn.com/video/475306257_800.jpg)](https://vimeo.com/95376358)   
[See the video on vimeo ](https://vimeo.com/95376358)

Used in conjunction with [POP](https://github.com/facebook/pop) this allows you to do really awesome stuff. Visit [AGGeometryKit+POP](https://github.com/hfossli/AGGeometryKit-Pop).   

[![Demo video](https://i.vimeocdn.com/video/475306176_800.jpg)](https://vimeo.com/95383807)   
[See the video on vimeo ](https://vimeo.com/95383807)


## Quadrilaterals

A quadrilateral is a polygon with four sides (or edges) and four vertices or corners. AGGeometryKit gives you lets you control each corner point individually.

You can access `quadrilateral` as a property just like you would do with `frame`, `center` or `bounds`. The coordinates is in same coordinate system as `frame` and `position`. You can use the quadrilateral on any UIView or CALayer - even webviews - with just as good performance as you would have not using it. The underlying technology is CATransform3D. More about quadrilaterals: http://en.wikipedia.org/wiki/Quadrilateral

    UIView *view = ...; // create a view
    [view.layer ensureAnchorPointIsSetToZero]; // set the anchor point to [0, 0] (this method keeps the same position)
    
    AGQuad quad = view.layer.quadrilateral; 
    quad.br.x += 20; // shift bottom right x-value with 20 pixels
    quad.br.y += 50; // shift bottom right y-value with 50 pixels
    
    view.layer.quadrilateral = quad; // the quad is converted to CATransform3D and applied


## UIView and CALayer properties

Example of some of the properties which is added to UIView and CALayer. Naming is done in same manner as `CGRectGetMaxX` for consistency.

	...
	@property (nonatomic, assign) CGPoint frameOrigin;
	@property (nonatomic, assign) CGFloat frameMinX;
	@property (nonatomic, assign) CGFloat frameMinY;
	@property (nonatomic, assign) CGFloat frameMidX;
	@property (nonatomic, assign) CGFloat frameMidY;
	@property (nonatomic, assign) CGFloat frameMaxX;
	@property (nonatomic, assign) CGFloat frameMaxY;
	@property (nonatomic, assign) CGFloat frameWidth;
	@property (nonatomic, assign) CGFloat frameHeight;
	...




## CGGeometry-additions

Some of the most useful functions

	...
	CGRect  CGRectInterpolate_AGK(CGRect rect1, CGRect rect2, CGFloat progress);
	CGSize  CGRectGapBetween_AGK(CGRect rect1, CGRect rect2);
	CGPoint CGPointClamp_AGK(CGPoint p, CGFloat minX, CGFloat maxX, CGFloat minY, CGFloat maxY);
	CGPoint CGPointAdd_AGK(CGPoint p1, CGPoint p2);
	...




## Math

Some of the most useful functions

	...
	CGFloat AGKInterpolate(CGFloat startValue, CGFloat endValue, CGFloat progress);
	CGFloat AGKRemapToZeroOne(CGFloat value, CGFloat startValue, CGFloat endValue);
	CGFloat AGKRemap(CGFloat value, CGFloat oldStartValue, CGFloat oldEndValue, CGFloat newStartValue, CGFloat newEndValue);
	CGFloat AGKRemapAndClamp(CGFloat value, CGFloat oldStartValue, CGFloat oldEndValue, CGFloat newStartValue, CGFloat newEndValue);
	CGFloat AGKRemapToZeroOneAndClamp(CGFloat value, CGFloat oldStartValue, CGFloat oldEndValue);
	CGFloat AGKClamp(CGFloat value, CGFloat min, CGFloat max);

	CGFloat AGKRadiansToDegrees(CGFloat radians);
	CGFloat AGKDegreesToRadians(CGFloat degrees);
	...



## Debugging quadrilaterals

- anchorPoint must be {0, 0} always when using quadrilaterals
- the quadrilateral must be convex
- don't modify the frame, but instead use `layer.position` or `view.center` and `layer.bounds` or `view.bounds`
- quadrilateral can not be used in conjunction with other CATransform3D-things like perspective, scale, rotate etc
- remember the coordinate system for the `quadrilateral`-property is in the same coordinate as `frame` and `position`
- don't make your values too extreme - they might cause application crash.
- check if the autoresizing mask might be altering the frame (to be 100% sure it is good for debugging to turn off `autoresizesSubviews`)

It can also be useful to create a representation of the quadrilateral you are trying to display using a UIBezierPath:

    UIView *quadPreview = [[UIView alloc] init];
    quadPreview.frame = quadView.frame;
    quadPreview.layer.shadowPath = [UIBezierPath bezierPathWithAGQuad:quad].CGPath;
    quadPreview.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5].CGColor;
    quadPreview.layer.shadowOpacity = 1.0;
    quadPreview.layer.shadowRadius = 0.0;
    quadPreview.layer.shadowOffset = CGSizeZero;
    quadPreview.backgroundColor = [UIColor clearColor];
    [quadView.superview addSubview:quadPreview];



## Useful links

* Bartosz Ciechanowski created a [genie effect](https://github.com/Ciechan/BCGenieEffect/) around desember 2012 using quadrilaterals
* [Quadrilaterals on stackoverflow](http://stackoverflow.com/a/12820877/558816)
* Want to work with us? Visit [agens.no](http://agens.no/)





## Keywords

Convex quadrilateral, simple quadrilateral, tangential, kite, rhombus, square, trapezium, trapezoid, parallelogram, bicentric, cyclic




## Who's behind this?

Agens.no a company situated in Oslo, Norway with some help from some very clever stackoverflow.com guys.


[![Agens | Digital craftsmanship](http://static.agens.no/images/agens_logo_w_slogan_avenir_small.png)](http://agens.no/)
