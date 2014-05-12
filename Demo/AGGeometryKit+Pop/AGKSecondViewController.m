//
//  AGKSecondViewController.m
//  AGGeometryKit+Pop
//
//  Created by Håvard Fossli on 08.05.14.
//  Copyright (c) 2014 Agens AS. All rights reserved.
//

#import "AGKSecondViewController.h"
#import "AGKQuad.h"
#import "CALayer+AGKQuad.h"
#import "CALayer+AGK+Methods.h"
#import "UIView+AGK+Properties.h"
#import "UIBezierPath+AGKQuad.h"
#import "POPAnimatableProperty+AGGeometryKit.h"
#import "CGGeometry+AGGeometryKit.h"
#import <pop/POP.h>
#import "AGGeometryKit.h"

@interface AGKSecondViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, assign) AGKQuad desiredQuad;

@end

@implementation AGKSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.imageView.layer ensureAnchorPointIsSetToZero];

}

- (void)viewDidAppear:(BOOL)animated
{
    self.desiredQuad = self.imageView.layer.outerQuadrilateral;
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

- (IBAction)panGestureChanged:(UIPanGestureRecognizer *)recognizer
{
    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case 0:
            [self panGestureChanged:recognizer animationTuning:^(POPSpringAnimation *anim, int cornerIndex, CGFloat dragCoefficient) {
                anim.springBounciness   = 4;
                anim.springSpeed        = 20;
                anim.dynamicsMass       = 1;
                anim.dynamicsFriction   = 37;
                anim.dynamicsTension    = AGKInterpolate(230, 400, dragCoefficient);
            }];
        case 1:
            [self panGestureChanged:recognizer animationTuning:^(POPSpringAnimation *anim, int cornerIndex, CGFloat dragCoefficient) {
                anim.springBounciness   = AGKInterpolate(0, 10, dragCoefficient);
                anim.dynamicsMass       = 1;
                anim.dynamicsFriction   = 37;
                anim.dynamicsTension    = 350;
                anim.springSpeed        = AGKInterpolate(4, 20, dragCoefficient);
            }];
            break;
        default:
            [self panGestureChanged:recognizer animationTuning:^(POPSpringAnimation *anim, int cornerIndex, CGFloat dragCoefficient) {
                anim.springBounciness   = AGKInterpolate(0, 10, dragCoefficient);
                anim.dynamicsMass       = AGKInterpolate(1, 1, dragCoefficient);
                anim.dynamicsFriction   = AGKInterpolate(37, 37, dragCoefficient);
                anim.dynamicsTension    = AGKInterpolate(350, 350, dragCoefficient);
                anim.springSpeed        = AGKInterpolate(4, 20, dragCoefficient);
            }];
            break;
    }
}

@end
