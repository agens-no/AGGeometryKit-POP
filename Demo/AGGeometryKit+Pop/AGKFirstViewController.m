//
//  AGKFirstViewController.m
//  AGGeometryKit+Pop
//
//  Created by Håvard Fossli on 08.05.14.
//  Copyright (c) 2014 Agens AS. All rights reserved.
//

#import "AGKFirstViewController.h"
#import <AGGeometryKit/AGGeometryKit.h>
#import "POPAnimatableProperty+AGGeometryKit.h"
#import <pop/POP.h>


@interface AGKFirstViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIView *imageView;

@end


@implementation AGKFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.imageView.layer ensureAnchorPointIsSetToZero];
}

- (IBAction)gestureChanged:(UIGestureRecognizer *)recognizer
{
    UIImageView *view = (UIImageView *)[recognizer view];
    CGPoint pointOfTouchInside = [recognizer locationInView:view];
    CGPoint touchAnchor = CGPointClamp_AGK(CGPointConvertToAnchorPoint_AGK(pointOfTouchInside, view.bounds), 0.0, 1.0, 0.0, 1.0);

    AGKQuad desiredQuad = AGKQuadMakeWithCGRect((CGRect){view.layer.position, view.bounds.size});

    CGFloat maxInsetX = 0.1;
    CGFloat maxInsetY = 0.08;

    if(recognizer.state != UIGestureRecognizerStateEnded)
    {
        desiredQuad.tl.x = AGKInterpolate(desiredQuad.tl.x, desiredQuad.tr.x, AGKRemap(touchAnchor.x, 0.0, 1.0, maxInsetX, 0.03));
        desiredQuad.tl.y = AGKInterpolate(desiredQuad.tl.y, desiredQuad.bl.y, AGKRemap(touchAnchor.x, 0.0, 1.0, maxInsetY, 0.03));
        desiredQuad.tr.x = AGKInterpolate(desiredQuad.tr.x, desiredQuad.tl.x, AGKRemap(touchAnchor.x, 1.0, 0.0, maxInsetX, 0.03));
        desiredQuad.tr.y = AGKInterpolate(desiredQuad.tr.y, desiredQuad.br.y, AGKRemap(touchAnchor.x, 1.0, 0.0, maxInsetY, 0.03));
    }

    NSArray *cornersForProperties = @[kPOPLayerAGKQuadTopLeft, kPOPLayerAGKQuadTopRight, kPOPLayerAGKQuadBottomRight, kPOPLayerAGKQuadBottomLeft];

    for(int cornerIndex = 0; cornerIndex < 4; cornerIndex++)
    {
        NSString *propertyName = cornersForProperties[cornerIndex];

        POPSpringAnimation *anim = [view.layer pop_animationForKey:propertyName];
        if(anim == nil)
        {
            anim = [POPSpringAnimation animation];
            anim.property = [POPAnimatableProperty AGKPropertyWithName:propertyName];
            [view.layer pop_addAnimation:anim forKey:propertyName];
        }

        anim.springSpeed = 14;
        anim.springBounciness = 15;
        anim.toValue = [NSValue valueWithCGPoint:desiredQuad.v[cornerIndex]];
    }

}

@end
