//
//  ICDMaterialProgressView.m
//  ICDUI
//
//  Created by LEI on 12/28/14.
//  Copyright (c) 2014 TouchingApp. All rights reserved.
//

#import "ICDMaterialActivityIndicatorView.h"

@interface ICDMaterialActivityIndicatorLayer : CAShapeLayer
@property (nonatomic) CGFloat radius;

@end

@implementation ICDMaterialActivityIndicatorLayer

- (instancetype)init{
    self = [super init];
    if (self){
        self.fillColor = [[UIColor clearColor] CGColor];
        self.lineCap = kCALineJoinRound;
    }
    return self;
}

- (void)setRadius:(CGFloat)radius{
    _radius = radius;
    self.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0 * self.radius, 2.0 * self.radius) cornerRadius:self.radius].CGPath;
}

@end

@interface ICDMaterialActivityIndicatorView ()
@property(nonatomic, readwrite, getter=isAnimating) BOOL animating;
@property(strong, nonatomic) ICDMaterialActivityIndicatorLayer *indicatorLayer;
@end

@implementation ICDMaterialActivityIndicatorView

- (instancetype)init{
    return [self initWithActivityIndicatorStyle:ICDMaterialActivityIndicatorViewStyleSmall];
}

- (instancetype)initWithActivityIndicatorStyle:(ICDMaterialActivityIndicatorViewStyle)style{
    return [self initWithFrame:CGRectZero activityIndicatorStyle:style];
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame activityIndicatorStyle:ICDMaterialActivityIndicatorViewStyleSmall];
}

- (instancetype)initWithFrame:(CGRect)frame activityIndicatorStyle:(ICDMaterialActivityIndicatorViewStyle)style{
    CGFloat lineWidth;
    CGFloat duration;
    CGFloat radius;
    switch (style) {
        case ICDMaterialActivityIndicatorViewStyleSmall:
            lineWidth = 1.0;
            duration = 0.8;
            radius = 10;
            break;
        case ICDMaterialActivityIndicatorViewStyleMedium:
            lineWidth = 2.0;
            duration = 0.8;
            radius = 15;
            break;
        case ICDMaterialActivityIndicatorViewStyleLarge:
            lineWidth = 3.0;
            duration = 1.0;
            radius = 30;
            break;
    }
    if (CGRectEqualToRect(frame, CGRectZero)){
        frame = CGRectMake(0, 0, radius * 2, radius * 2);
    }
    self = [super initWithFrame:frame];
    if (self){
        _hidesWhenStopped = YES;
        _animating = NO;
        self.duration = duration;
        self.color = [UIColor colorWithRed:39/255. green:140/255. blue:227/255. alpha:1.0];
        self.lineWidth = lineWidth;
        self.hidden = YES;
        [self.layer addSublayer:self.indicatorLayer];
        self.indicatorLayer.radius = radius;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.indicatorLayer.frame = CGRectMake((self.bounds.size.width - 2.0 * self.indicatorLayer.radius) / 2.0 , (self.bounds.size.height - 2.0 * self.indicatorLayer.radius) / 2.0, 2.0 * self.indicatorLayer.radius, 2.0 * self.indicatorLayer.radius);
}

- (ICDMaterialActivityIndicatorLayer *)indicatorLayer{
    if (!_indicatorLayer){
        _indicatorLayer = [[ICDMaterialActivityIndicatorLayer alloc]init];
    }
    return _indicatorLayer;
}

- (void)setColor:(UIColor *)color{
    _color = color;
    self.indicatorLayer.strokeColor = self.color.CGColor;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    self.indicatorLayer.lineWidth = self.lineWidth;
    [self setNeedsDisplay];
}

- (void)setDuration:(CGFloat)duration{
    _duration = duration;
    [self resetAnimations];
}

- (void)resetAnimations{
    [self.indicatorLayer removeAllAnimations];
    [self.indicatorLayer addAnimation:[self createNewStrokeAnimation] forKey:@"rotation"];
    [self.indicatorLayer addAnimation:[self createNewRotateAnimation] forKey:@"stroke"];
}

- (CAAnimationGroup *)createNewStrokeAnimation{
    CAKeyframeAnimation *inAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    inAnimation.duration = self.duration;
    inAnimation.values = @[@(0), @(1)];
    
    CAKeyframeAnimation *outAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    outAnimation.duration = self.duration;
    outAnimation.values = @[@(0), @(0.8), @(1)];
    outAnimation.beginTime = self.duration / 1.5;
    
    CAAnimationGroup *strokeAnimation = [CAAnimationGroup animation];
    strokeAnimation.animations = @[inAnimation, outAnimation];
    strokeAnimation.duration = self.duration + outAnimation.beginTime;
    strokeAnimation.repeatCount = INFINITY;
    strokeAnimation.timeOffset = self.progress;
    return strokeAnimation;
}

- (CABasicAnimation *)createNewRotateAnimation{
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = @(0);
    rotateAnimation.toValue = @(M_PI * 2);
    rotateAnimation.duration = self.duration * 1.5;
    rotateAnimation.repeatCount = INFINITY;
    rotateAnimation.timeOffset = self.progress;
    return rotateAnimation;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    if (!self.isAnimating){
        [self.indicatorLayer removeAllAnimations];
        CAAnimationGroup *strokeAnimation = [self createNewStrokeAnimation];
        strokeAnimation.speed = 0;
        [self.indicatorLayer addAnimation:strokeAnimation forKey:@"rotation"];
        
        CABasicAnimation *rotateAnimation = [self createNewRotateAnimation];
        rotateAnimation.speed = 0;
        [self.indicatorLayer addAnimation:rotateAnimation forKey:@"stroke"];
        self.hidden = NO;
    }
}

-(void)pauseLayer:(CALayer*)layer{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void)startAnimating{
    if (self.isAnimating) {
        return;
    }
    self.animating = YES;
    self.hidden = NO;
    [self resetAnimations];
    self.indicatorLayer.speed = 1;
}

- (void)stopAnimating{
    if (!self.isAnimating){
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.alpha = 1.0;
        self.hidden = self.hidesWhenStopped;
        [self.indicatorLayer removeAllAnimations];
        self.animating = NO;
    }];
}

@end
