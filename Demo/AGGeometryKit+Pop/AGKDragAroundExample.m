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

#import "AGKDragAroundExample.h"
#import "AGKQuad.h"
#import "CALayer+AGKQuad.h"
#import "CALayer+AGK+Methods.h"
#import "UIView+AGK+Properties.h"
#import "UIBezierPath+AGKQuad.h"
#import "POPAnimatableProperty+AGGeometryKit.h"
#import "CGGeometry+AGGeometryKit.h"
#import <pop/POP.h>
#import "AGGeometryKit.h"

@interface AGKDragAroundExample ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, assign) AGKQuad desiredQuad;

@end

@implementation AGKDragAroundExample

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.imageView.layer ensureAnchorPointIsSetToZero];

}

- (void)viewDidAppear:(BOOL)animated
{
    self.desiredQuad = self.imageView.layer.quadrilateral;
}

- (CGFloat)longestDistanceOfPointsInQuad:(AGKQuad)quad toPoint:(CGPoint)point
{
    CGFloat longestDistanceFromTouch = 0.0;

    for(int cornerIndex = 0; cornerIndex < 4; cornerIndex++)
    {
        CGPoint currentCornerPoint = quad.v[cornerIndex];
        CGFloat distance = fabs(CGPointLengthBetween_AGK(point, currentCornerPoint));

        if(distance > longestDistanceFromTouch)
        {
            longestDistanceFromTouch = distance;
        }
    }
    return longestDistanceFromTouch;
}

- (IBAction)panGestureChanged:(UIPanGestureRecognizer *)recognizer
{
    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case 0:
            [self panGestureChanged:recognizer animationTuning:^(POPSpringAnimation *anim, int cornerIndex, CGFloat dragCoefficient) {
                anim.dynamicsMass       = 1;
                anim.dynamicsFriction   = 37;
                anim.dynamicsTension    = 2;
                anim.springBounciness   = AGKInterpolate(4, 12, dragCoefficient);
                anim.springSpeed        = AGKInterpolate(10, 50, dragCoefficient);
            }];
            break;
        case 1:
            [self panGestureChanged:recognizer animationTuning:^(POPSpringAnimation *anim, int cornerIndex, CGFloat dragCoefficient) {
                anim.dynamicsMass       = 100;
                anim.dynamicsFriction   = 37;
                anim.dynamicsTension    = 2;
                anim.springBounciness   = AGKInterpolate(10, 20, dragCoefficient);
                anim.springSpeed        = AGKInterpolate(10, 20, dragCoefficient);
            }];
            break;
        case 2:
        default:
            [self panGestureChanged:recognizer animationTuning:^(POPSpringAnimation *anim, int cornerIndex, CGFloat dragCoefficient) {
                anim.dynamicsMass       = 100;
                anim.dynamicsFriction   = 37;
                anim.dynamicsTension    = 2;
                anim.springBounciness   = AGKInterpolate(5, 12, dragCoefficient);
                anim.springSpeed        = AGKInterpolate(4, 7, dragCoefficient);
            }];
            break;
    }
}

- (void)panGestureChanged:(UIPanGestureRecognizer *)recognizer animationTuning:(void(^)(POPSpringAnimation *anim, int cornerIndex, CGFloat dragCoefficient))tuning
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint pointOfTouchInside = [recognizer locationInView:recognizer.view];
    self.desiredQuad = AGKQuadMove(self.desiredQuad, translation.x, translation.y);
    AGKQuad innerQuad = [recognizer.view.layer.superlayer convertAGKQuad:self.desiredQuad toLayer:recognizer.view.layer];
    NSArray *cornersForProperties = @[kPOPLayerAGKQuadTopLeft, kPOPLayerAGKQuadTopRight, kPOPLayerAGKQuadBottomRight, kPOPLayerAGKQuadBottomLeft];
    CGFloat longestDistanceFromTouch = [self longestDistanceOfPointsInQuad:innerQuad toPoint:pointOfTouchInside];

    for(int cornerIndex = 0; cornerIndex < 4; cornerIndex++)
    {
        NSString *propertyName = cornersForProperties[cornerIndex];

        POPSpringAnimation *anim = [self.imageView.layer pop_animationForKey:propertyName];
        if(anim == nil)
        {
            anim = [POPSpringAnimation animation];
            anim.property = [POPAnimatableProperty AGKPropertyWithName:propertyName];
            [self.imageView.layer pop_addAnimation:anim forKey:propertyName];
        }

        CGPoint currentCornerPoint = innerQuad.v[cornerIndex];
        CGFloat distance = fabs(CGPointLengthBetween_AGK(pointOfTouchInside, currentCornerPoint));
        CGFloat dragCoefficient = AGKRemapToZeroOne(distance, longestDistanceFromTouch, 0);

        anim.toValue = [NSValue valueWithCGPoint:self.desiredQuad.v[cornerIndex]];
        tuning(anim, cornerIndex, dragCoefficient);
    }

    [recognizer setTranslation:CGPointZero inView:self.view];
}

@end
