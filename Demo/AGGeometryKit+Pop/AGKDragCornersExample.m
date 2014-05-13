//
// Author: Håvard Fossli <hfossli@agens.no>
//
// Copyright (c) 2013 Agens AS (http://agens.no/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AGKDragCornersExample.h"
#import "AGKQuad.h"
#import "CALayer+AGKQuad.h"
#import "CALayer+AGK+Methods.h"
#import "UIView+AGK+Properties.h"
#import "UIBezierPath+AGKQuad.h"
#import "POPAnimatableProperty+AGGeometryKit.h"
#import <pop/POP.h>

@interface AGControlPointView : UIView

@end

@interface AGKDragCornersExample ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIView *topLeftControl;
@property (nonatomic, strong) IBOutlet UIView *topRightControl;
@property (nonatomic, strong) IBOutlet UIView *bottomLeftControl;
@property (nonatomic, strong) IBOutlet UIView *bottomRightControl;

@end


@implementation AGKDragCornersExample

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.imageView.layer ensureAnchorPointIsSetToZero];

    self.imageView.layer.quadrilateral = AGKQuadMake(self.topLeftControl.center,
                                                          self.topRightControl.center,
                                                          self.bottomRightControl.center,
                                                          self.bottomLeftControl.center);
}

- (void)panGestureChanged:(UIPanGestureRecognizer *)recognizer propertyName:(NSString *)propertyName
{
    UIImageView *view = (UIImageView *)[recognizer view];
    CGPoint velocity = [recognizer velocityInView:self.view];
    CGPoint translation = [recognizer translationInView:self.view];

    // Move control point
    view.centerX += translation.x;
    view.centerY += translation.y;
    [recognizer setTranslation:CGPointZero inView:self.view];

    // Animate quadrilateral for imageview
    POPSpringAnimation *anim = [self.imageView.layer pop_animationForKey:propertyName];

    if(anim == nil)
    {
        anim = [POPSpringAnimation animation];
        anim.property = [POPAnimatableProperty AGKPropertyWithName:propertyName];
        [self.imageView.layer pop_addAnimation:anim forKey:propertyName];
    }

    anim.velocity = [NSValue valueWithCGPoint:velocity];
    anim.toValue = [NSValue valueWithCGPoint:view.center];

    anim.springBounciness = 1;
    anim.springSpeed = 7;
    anim.dynamicsFriction = 7;

    view.highlighted = recognizer.state != UIGestureRecognizerStateEnded;
}

- (IBAction)topLeftChanged:(UIPanGestureRecognizer *)recognizer
{
    [self panGestureChanged:recognizer propertyName:kPOPLayerAGKQuadTopLeft];
}

- (IBAction)topRightChanged:(UIPanGestureRecognizer *)recognizer
{
    [self panGestureChanged:recognizer propertyName:kPOPLayerAGKQuadTopRight];
}

- (IBAction)bottomLeftChanged:(UIPanGestureRecognizer *)recognizer
{
    [self panGestureChanged:recognizer propertyName:kPOPLayerAGKQuadBottomLeft];
}

- (IBAction)bottomRightChanged:(UIPanGestureRecognizer *)recognizer
{
    [self panGestureChanged:recognizer propertyName:kPOPLayerAGKQuadBottomRight];
}

@end
