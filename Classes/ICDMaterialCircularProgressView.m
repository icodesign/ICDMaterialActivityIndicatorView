//
//  ICDMaterialProgressView.m
//  ICDUI
//
//  Created by LEI on 12/28/14.
//  Copyright (c) 2014 TouchingApp. All rights reserved.
//

#import "ICDMaterialCircularProgressView.h"
#import <POP.h>

@interface ICDMaterialCircularProgressView () {
    NSTimer *_timer;
}
@property (nonatomic, getter=isAnimating, readwrite) BOOL animating;
@end

@implementation ICDMaterialCircularProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self defaultInitialize];
    }
    return self;
}

- (void)defaultInitialize{
    self.roundedCorners = NO;
    self.trackTintColor = [UIColor clearColor];
    self.progressTintColor = [UIColor colorWithRed:39/255. green:140/255. blue:227/255. alpha:1.0];
    self.thicknessRatio = 0.15;
    self.indeterminate = NO;
    self.progress = 0;
    self.startProgress = 0;
    self.animating = NO;
}

- (void)setAnimating:(BOOL)animating{
    _animating = animating;
    if (self.isAnimating){
        self.progress = 0.1;
        self.startProgress = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.05f target:self selector:@selector(animate) userInfo:nil repeats:YES];
        [_timer fire];
    }else{
        self.progress = 0;
        self.startProgress = 0;
        [self pop_removeAllAnimations];
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)beginAnimation{
    self.animating = YES;
}

- (void)stopAnimation{
    self.animating = NO;
}

- (void)animate{
    __block CGFloat randomProgress = 0.2;
    POPBasicAnimation *startProgressPendingLinearAnimation = [self linearAnimationForProperty:@"startProgress"];
    startProgressPendingLinearAnimation.fromValue = @(self.startProgress);
    startProgressPendingLinearAnimation.toValue = @(1+self.startProgress);
    startProgressPendingLinearAnimation.duration = 1.4;
    startProgressPendingLinearAnimation.removedOnCompletion = YES;
    startProgressPendingLinearAnimation.beginTime = CACurrentMediaTime() + 0;
    [self pop_addAnimation:startProgressPendingLinearAnimation forKey:@"startProgressPendingLinearAnimation"];
    
    POPBasicAnimation *progressEaseInOutAnimation = [self easeInOutAnimationForProperty:@"progress"];
    progressEaseInOutAnimation.fromValue = @(self.progress);
    progressEaseInOutAnimation.toValue = @(0.8 + self.progress);
    progressEaseInOutAnimation.duration = 1.2;
    progressEaseInOutAnimation.removedOnCompletion = YES;
    progressEaseInOutAnimation.beginTime = CACurrentMediaTime() + randomProgress;
    __weak typeof(self) weakSelf = self;
    progressEaseInOutAnimation.completionBlock = ^(POPAnimation *animation, BOOL finished){
        if (finished){
            POPBasicAnimation *startProgressEndingAnimation = [self easeInOutAnimationForProperty:@"startProgress"];
            startProgressEndingAnimation.fromValue = @(self.startProgress);
            startProgressEndingAnimation.toValue = @(self.startProgress + 1);
            startProgressEndingAnimation.duration = 2 - (1.2 + randomProgress);
            startProgressEndingAnimation.removedOnCompletion = YES;
            [weakSelf pop_addAnimation:startProgressEndingAnimation forKey:@"startProgressEndingAnimation"];
            
            POPBasicAnimation *progressEndingAnimation = [self easeInOutAnimationForProperty:@"progress"];
            progressEndingAnimation.fromValue = @(self.progress);
            progressEndingAnimation.toValue = @(self.progress - 0.8);
            progressEndingAnimation.duration = 2 - (1.2 + randomProgress);
            progressEndingAnimation.removedOnCompletion = YES;
            [weakSelf pop_addAnimation:progressEndingAnimation forKey:@"progressEndingAnimation"];
        }
    };
    [self pop_addAnimation:progressEaseInOutAnimation forKey:@"progressEaseInOutAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag){
        
    }
}

- (POPBasicAnimation *)easeInOutAnimationForProperty: (NSString *)property{
    POPBasicAnimation *animation = [self animationForProperty:property];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

- (POPBasicAnimation *)linearAnimationForProperty: (NSString *)property{
    POPBasicAnimation *animation = [self animationForProperty:property];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return animation;
}

- (POPBasicAnimation *)animationForProperty: (NSString *)property{
    POPBasicAnimation *animation = [POPBasicAnimation animation];
    animation.property = [POPMutableAnimatableProperty propertyWithName:@"startProgress" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(id object, CGFloat *values){
            
        };
        prop.writeBlock = ^(id object, const CGFloat *values){
            [self setValue:@(values[0]) forKey:property];
        };
    }];
    return animation;
}

@end
