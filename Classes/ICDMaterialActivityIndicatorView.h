//
//  ICDMaterialProgressView.h
//  ICDUI
//
//  Created by LEI on 12/28/14.
//  Copyright (c) 2014 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum: NSInteger{
    ICDMaterialActivityIndicatorViewStyleSmall,
    ICDMaterialActivityIndicatorViewStyleMedium,
    ICDMaterialActivityIndicatorViewStyleLarge
}ICDMaterialActivityIndicatorViewStyle;

@interface ICDMaterialActivityIndicatorView : UIView

- (instancetype)initWithActivityIndicatorStyle:(ICDMaterialActivityIndicatorViewStyle)style;
- (instancetype)initWithFrame:(CGRect)frame activityIndicatorStyle:(ICDMaterialActivityIndicatorViewStyle)style;
@property(nonatomic) ICDMaterialActivityIndicatorViewStyle activityIndicatorViewStyle; // default is ICDMaterialActivityIndicatorViewStyleSmall
@property(nonatomic) BOOL hidesWhenStopped;           // default is YES. calls -setHidden when animating gets set to NO
@property(nonatomic, readonly, getter=isAnimating) BOOL animating;

@property (copy, nonatomic) UIColor *color;
@property (nonatomic) CGFloat duration;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat progress;


- (void)startAnimating;
- (void)stopAnimating;

@end
