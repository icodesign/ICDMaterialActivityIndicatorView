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
    self.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.bounds.size.width - 2.0 *self.radius) / 2.0 , (self.bounds.size.height - 2.0 *self.radius) / 2.0, 2.0 * self.radius, 2.0 * self.radius) cornerRadius:self.radius].CGPath;
}

@end

@interface ICDMaterialActivityIndicatorView ()
@property(nonatomic, readwrite, getter=isAnimating) BOOL animating;
@end

@implementation ICDMaterialActivityIndicatorView

- (instancetype)init{
    return [self initWithActivityIndicatorStyle:ICDMaterialActivityIndicatorViewStyleSmall];
}

- (instancetype)initWithActivityIndicatorStyle:(ICDMaterialActivityIndicatorViewStyle)style{
    CGRect frame;
    switch (style) {
        case ICDMaterialActivityIndicatorViewStyleSmall:
            frame = CGRectMake(0, 0, 20, 20);
            break;
        case ICDMaterialActivityIndicatorViewStyleMedium:
            frame = CGRectMake(0, 0, 30, 30);
            break;
        case ICDMaterialActivityIndicatorViewStyleLarge:
            frame = CGRectMake(0, 0, 60, 60);
            break;
    }
    return [self initWithFrame:frame activityIndicatorStyle:style];
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame activityIndicatorStyle:ICDMaterialActivityIndicatorViewStyleSmall];
}

- (instancetype)initWithFrame:(CGRect)frame activityIndicatorStyle:(ICDMaterialActivityIndicatorViewStyle)style{
    CGFloat lineWidth;
    CGFloat duration;
    switch (style) {
        case ICDMaterialActivityIndicatorViewStyleSmall:
            lineWidth = 2.0;
            duration = 0.8;
            break;
        case ICDMaterialActivityIndicatorViewStyleMedium:
            lineWidth = 4.0;
            duration = 0.8;
            break;
        case ICDMaterialActivityIndicatorViewStyleLarge:
            lineWidth = 8.0;
            duration = 1.0;
            break;
    }
    self = [super initWithFrame:frame];
    if (self){
        _duration = duration;
        _hidesWhenStopped = YES;
        _animating = NO;
        self.color = [UIColor colorWithRed:39/255. green:140/255. blue:227/255. alpha:1.0];
        self.lineWidth = lineWidth;
        self.hidden = YES;
        [self indicatorLayer].frame = self.frame;
        [self indicatorLayer].radius = self.frame.size.width / 2.0;
    }
    return self;
}

+ (Class)layerClass{
    return [ICDMaterialActivityIndicatorLayer class];
}

- (ICDMaterialActivityIndicatorLayer *)indicatorLayer{
    return (ICDMaterialActivityIndicatorLayer *)self.layer;
}

- (void)setColor:(UIColor *)color{
    _color = color;
    [self indicatorLayer].strokeColor = self.color.CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    [self indicatorLayer].lineWidth = self.lineWidth;
}

- (void)startAnimating{
    if (self.isAnimating) {
        return;
    }
    self.animating = YES;
}

- (void)stopAnimating{
    if (!self.isAnimating){
        return;
    }
    self.animating = NO;
}

- (void)setAnimating:(BOOL)animating{
    if (animating){
        self.hidden = NO;
        CAKeyframeAnimation *inAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
        inAnimation.duration = self.duration;
        inAnimation.values = @[@(0), @(1)];
        
        CAKeyframeAnimation *outAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
        outAnimation.duration = self.duration;
        outAnimation.values = @[@(0), @(0.8), @(1)];
        outAnimation.beginTime = self.duration / 1.5;
        
        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        groupAnimation.animations = @[inAnimation, outAnimation];
        groupAnimation.duration = self.duration + outAnimation.beginTime;
        groupAnimation.repeatCount = INFINITY;
        groupAnimation.delegate = self;
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = @(0);
        rotationAnimation.toValue = @(M_PI * 2);
        rotationAnimation.duration = self.duration * 1.5;
        rotationAnimation.repeatCount = INFINITY;
        
        [[self indicatorLayer] addAnimation:rotationAnimation forKey:@"rotation"];
        [[self indicatorLayer] addAnimation:groupAnimation forKey:@"stroke"];
        _animating = YES;
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.alpha = 1.0;
            self.hidden = self.hidesWhenStopped;
            [[self indicatorLayer] removeAllAnimations];
            _animating = NO;
        }];
    }
}



@end
