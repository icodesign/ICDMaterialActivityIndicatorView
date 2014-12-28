//
//  ICDMaterialProgressView.h
//  ICDUI
//
//  Created by LEI on 12/28/14.
//  Copyright (c) 2014 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"

@interface ICDMaterialCircularProgressView : DACircularProgressView
@property (nonatomic, getter=isAnimating, readonly) BOOL animating;

- (void)beginAnimation;
- (void)stopAnimation;
@end
