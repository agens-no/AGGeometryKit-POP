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

#import "AGKTapCardExample.h"
#import <AGGeometryKit/AGGeometryKit.h>
#import "POPAnimatableProperty+AGGeometryKit.h"
#import <pop/POP.h>


@interface AGKTapCardExample () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIView *imageView;

@end


@implementation AGKTapCardExample

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

    if(recognizer.state != UIGestureRecognizerStateEnded)
    {
        const CGFloat maxInsetX = 0.1;
        const CGFloat maxInsetY = 0.08;
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
