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
    CGFloat _scheduleTime;
    CGFloat _initialProgress;
    CGFloat _firstStartProgress;
    CGFloat _secondStartProgress;
    CGFloat _fullProgress;
    CGFloat _firstProgressPendingTime;
    CGFloat _firstStartProgressDuration;
    CGFloat _secondProgressDuration;
    CGFloat _secondStartProgressDuration;
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
    
    
    /***********
     
     (_secondStartProgress - _firstStartProgress)/(_secondProgressDuration) = (_firstStartProgress)/(_firstStartProgressDuration)
     (_secondStartProgress - _firstStartProgress)/(_secondProgressDuration) > (_fullProgress - _initialProgress)/(_secondProgressDuration)
     
     ***********/
    
    _initialProgress = 0.1;
    _firstStartProgress = 0.8;
    _secondStartProgress = 1.8;
    _fullProgress = 0.7;
    
    _firstProgressPendingTime = 0.1;
    _firstStartProgressDuration = 0.7;
    _secondProgressDuration = (_secondStartProgress - _firstStartProgress) * _firstStartProgressDuration / _firstStartProgress;
    _secondStartProgressDuration = _secondProgressDuration;
    
    _scheduleTime = _firstStartProgressDuration + _secondProgressDuration;
    
    NSLog(@"_scheduleTime: %f, _secondProgressDuration: %f", _scheduleTime, _secondStartProgressDuration);
}

- (void)setAnimating:(BOOL)animating{
    _animating = animating;
    if (self.isAnimating){
        self.progress = _initialProgress;
        self.startProgress = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:_scheduleTime + 0.05f target:self selector:@selector(animate) userInfo:nil repeats:YES];
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

    POPBasicAnimation *startProgressPendingLinearAnimation = [self linearAnimationForProperty:@"startProgress"];
    NSLog(@"startProgress: %f, progress: %f", self.startProgress, self.progress);
    startProgressPendingLinearAnimation.fromValue = @(self.startProgress);
    startProgressPendingLinearAnimation.toValue = @(_firstStartProgress + self.startProgress);
    startProgressPendingLinearAnimation.duration = _firstStartProgressDuration;
    startProgressPendingLinearAnimation.removedOnCompletion = YES;
    startProgressPendingLinearAnimation.beginTime = CACurrentMediaTime() + 0;
    [self pop_addAnimation:startProgressPendingLinearAnimation forKey:@"startProgressPendingLinearAnimation"];
    
    POPBasicAnimation *progressEaseInOutAnimation = [self easeInOutAnimationForProperty:@"progress"];
    progressEaseInOutAnimation.fromValue = @(self.progress);
    progressEaseInOutAnimation.toValue = @(self.progress + _fullProgress);
    progressEaseInOutAnimation.duration = _firstStartProgressDuration - _firstProgressPendingTime;
    progressEaseInOutAnimation.removedOnCompletion = YES;
    progressEaseInOutAnimation.beginTime = CACurrentMediaTime() + _firstProgressPendingTime;
    
    [self pop_addAnimation:progressEaseInOutAnimation forKey:@"progressEaseInOutAnimation"];
    
    POPBasicAnimation *startProgressEndingAnimation = [self linearAnimationForProperty:@"startProgress"];
    startProgressEndingAnimation.fromValue = @(_firstStartProgress + self.startProgress);
    startProgressEndingAnimation.toValue = @(_secondStartProgress + self.startProgress);
    startProgressEndingAnimation.duration = _secondStartProgressDuration;
    startProgressEndingAnimation.removedOnCompletion = YES;
    startProgressEndingAnimation.beginTime = CACurrentMediaTime() + _firstStartProgressDuration;
    [self pop_addAnimation:startProgressEndingAnimation forKey:@"startProgressEndingAnimation"];
    
    POPBasicAnimation *progressEndingAnimation = [self linearAnimationForProperty:@"progress"];
    progressEndingAnimation.fromValue = @(self.progress + _fullProgress);
    progressEndingAnimation.toValue = @(_initialProgress);
    progressEndingAnimation.duration = _secondProgressDuration;
    progressEndingAnimation.removedOnCompletion = YES;
    progressEndingAnimation.beginTime = CACurrentMediaTime() + _firstStartProgressDuration;
    [self pop_addAnimation:progressEndingAnimation forKey:@"progressEndingAnimation"];
    
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
