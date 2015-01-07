//
//  ViewController.m
//  ICDMaterialCircularProgressView
//
//  Created by LEI on 12/28/14.
//  Copyright (c) 2014 TouchingApp. All rights reserved.
//

#import "ViewController.h"
#import "ICDMaterialActivityIndicatorView.h"

@interface ViewController (){
    NSTimer *_timer;
}
@property (strong,nonatomic) ICDMaterialActivityIndicatorView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView = [[ICDMaterialActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 140, 320, 40) activityIndicatorStyle:ICDMaterialActivityIndicatorViewStyleSmall];
//    [self.progressView startAnimating];
    [self.view addSubview:self.progressView];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(animate) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)animate{
    static float p = 0.2;
    self.progressView.progress = p;
    if (p == 1){
        [self.progressView startAnimating];
        [_timer invalidate];
    }
    p += 0.2;
}

@end
