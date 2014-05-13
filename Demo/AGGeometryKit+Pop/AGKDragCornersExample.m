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
#import "AGGeometryKit.h"
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
    UIImageView *controlPointView = (UIImageView *)[recognizer view];
    CGPoint translation = [recognizer translationInView:self.view];

    // Highlight the controlpoint
    controlPointView.highlighted = recognizer.state == UIGestureRecognizerStateChanged;

    // Move control point
    controlPointView.centerX += translation.x;
    controlPointView.centerY += translation.y;
    [recognizer setTranslation:CGPointZero inView:self.view];

    // Animate
    POPSpringAnimation *anim = [self.imageView.layer pop_animationForKey:propertyName];

    if(anim == nil)
    {
        anim = [POPSpringAnimation animation];
        anim.property = [POPAnimatableProperty AGKPropertyWithName:propertyName];
        [self.imageView.layer pop_addAnimation:anim forKey:propertyName];
    }

    anim.velocity = [NSValue valueWithCGPoint:[recognizer velocityInView:self.view]];
    anim.toValue = [NSValue valueWithCGPoint:controlPointView.center];
    anim.springBounciness = 1;
    anim.springSpeed = 7;
    anim.dynamicsFriction = 7;
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
