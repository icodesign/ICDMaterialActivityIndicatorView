//
//  ViewController.m
//  ICDMaterialCircularProgressView
//
//  Created by LEI on 12/28/14.
//  Copyright (c) 2014 TouchingApp. All rights reserved.
//

#import "ViewController.h"
#import "ICDMaterialActivityIndicatorView.h"

@interface ViewController ()
@property (strong,nonatomic) ICDMaterialActivityIndicatorView *progressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.progressView = [[ICDMaterialActivityIndicatorView alloc]initWithFrame:CGRectMake(140, 140, 40, 40)];
    [self.progressView startAnimating];
    [self.view addSubview:self.progressView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
