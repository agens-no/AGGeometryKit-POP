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

#import "CALayer+AGKQuad.h"
#import "AGKCALayerAnimationBlockDelegate.h"
#import "CALayer+AGK+Methods.h"

@implementation CALayer (AGKQuad)

- (AGKQuad)quadrilateral
{
    if(!CGPointEqualToPoint(self.anchorPoint, CGPointZero))
    {
        [NSException raise:NSInternalInconsistencyException format:@"When reading quadrilateral value from CALayer the anchor point must be [0.0, 0.0]. You may for convenience use `-[CALayer ensureAnchorPointIsSetToZero]`"];
    }
    AGKQuad q = [self convertAGKQuad:AGKQuadMakeWithCGSize(self.bounds.size) toLayer:self.superlayer];
    return q;
}

- (void)setQuadrilateral:(AGKQuad)quadrilateral
{
    if(!AGKQuadEqual(quadrilateral, AGKQuadZero) && AGKQuadIsValid(quadrilateral))
    {
        AGKQuad innerQuadrilateral = AGKQuadMove(quadrilateral, -self.position.x, -self.position.y);
        CATransform3D t = CATransform3DWithAGKQuadFromBounds(innerQuadrilateral, self.bounds);

        [self ensureAnchorPointIsSetToZero];
        self.transform = t;
    }
}

- (AGKQuad)convertAGKQuad:(AGKQuad)quad fromLayer:(CALayer *)l
{
    AGKQuad q;
    q.tl = [self convertPoint:quad.tl fromLayer:l];
    q.tr = [self convertPoint:quad.tr fromLayer:l];
    q.br = [self convertPoint:quad.br fromLayer:l];
    q.bl = [self convertPoint:quad.bl fromLayer:l];
    return q;
}

- (AGKQuad)convertAGKQuad:(AGKQuad)quad toLayer:(CALayer *)layer
{
    AGKQuad q = quad;
    q.tl = [self convertPoint:quad.tl toLayer:layer];
    q.tr = [self convertPoint:quad.tr toLayer:layer];
    q.br = [self convertPoint:quad.br toLayer:layer];
    q.bl = [self convertPoint:quad.bl toLayer:layer];
    return q;
}

#pragma mark - Animation

+ (CAKeyframeAnimation *)animationBetweenQuadrilateral:(AGKQuad)quad1
                                      andQuadrilateral:(AGKQuad)quad2
                                             layerSize:(CGSize)layerSize
                                         layerPosition:(CGPoint)layerPosition
                                     forNumberOfFrames:(NSUInteger)numberOfFrames
                                                 delay:(NSTimeInterval)delay
                                              duration:(NSTimeInterval)duration
                                          easeFunction:(double(^)(double p))progressFunction
                                               onStart:(void(^)(void))onStart
                                            onComplete:(void(^)(BOOL finished))onComplete
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.beginTime = CACurrentMediaTime() + delay;

    NSMutableArray *values = [NSMutableArray arrayWithCapacity:numberOfFrames];

    for(int i = 0; i < numberOfFrames; i++)
    {
        double p = progressFunction((double)i / (double)numberOfFrames);
        AGKQuad quad = AGKQuadInterpolate(quad1, quad2, p);
        AGKQuad innerQuad = AGKQuadMove(quad, -layerPosition.x, -layerPosition.y);
        CATransform3D transform = CATransform3DWithAGKQuadFromBounds(innerQuad, (CGRect){CGPointZero, layerSize});
        NSValue *value = [NSValue valueWithCATransform3D:transform];
        [values addObject:value];
    }

    animation.values = values;
    animation.delegate = [AGKCALayerAnimationBlockDelegate newWithAnimationDidStart:onStart didStop:onComplete];

    return animation;
}

- (void)animateFromQuadrilateral:(AGKQuad)quad1
                 toQuadrilateral:(AGKQuad)quad2
               forNumberOfFrames:(NSUInteger)numberOfFrames
                        duration:(NSTimeInterval)duration
                           delay:(NSTimeInterval)delay
                         animKey:(NSString *)animKey
                    easeFunction:(double(^)(double p))progressFunction
                      onComplete:(void(^)(BOOL finished))onComplete
{
    if(!CGPointEqualToPoint(self.anchorPoint, CGPointZero))
    {
        [NSException raise:NSInternalInconsistencyException format:@"Before using any quadrilaterals the layers anchorPoint property must be {0, 0}. You may use the category method -[CALayer ensureAnchorPointIsSetToZero]"];
    }

    [CATransaction begin];

    __weak __typeof__(self) wself = self;

    CAKeyframeAnimation *anim = [[self class] animationBetweenQuadrilateral:quad1
                                                           andQuadrilateral:quad2
                                                                  layerSize:self.bounds.size
                                                              layerPosition:self.position
                                                          forNumberOfFrames:numberOfFrames
                                                                      delay:delay
                                                                   duration:duration
                                                               easeFunction:progressFunction
                                                                    onStart:^{
                                                                        wself.quadrilateral = quad2;
                                                                    } onComplete:^(BOOL finished) {
                                                                        if(finished)
                                                                        {
                                                                            [wself removeAnimationForKey:animKey];
                                                                        }
                                                                        if(onComplete)
                                                                        {
                                                                            onComplete(finished);
                                                                        }
                                                                    }];

    anim.removedOnCompletion = NO;

    [self addAnimation:anim forKey:animKey];

    [CATransaction commit];
}

- (void)animateFromPresentedStateToQuadrilateral:(AGKQuad)quad
                               forNumberOfFrames:(NSUInteger)numberOfFrames
                                        duration:(NSTimeInterval)duration
                                           delay:(NSTimeInterval)delay
                                         animKey:(NSString *)animKey
                                    easeFunction:(double(^)(double p))progressFunction
                                      onComplete:(void(^)(BOOL finished))onComplete
{
    AGKQuad currentQuad = [(CALayer *)[self presentationLayer] quadrilateral];
    
    [self animateFromQuadrilateral:currentQuad
                   toQuadrilateral:quad
                 forNumberOfFrames:numberOfFrames
                          duration:duration
                             delay:delay
                           animKey:animKey
                      easeFunction:progressFunction
                        onComplete:onComplete];
}


@end