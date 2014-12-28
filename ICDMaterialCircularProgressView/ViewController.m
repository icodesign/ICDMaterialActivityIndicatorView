//
//  ViewController.m
//  ICDMaterialCircularProgressView
//
//  Created by LEI on 12/28/14.
//  Copyright (c) 2014 TouchingApp. All rights reserved.
//

#import "ViewController.h"
#import "ICDMaterialCircularProgressView.h"

@interface ViewController ()
@property (strong,nonatomic) ICDMaterialCircularProgressView *progressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.progressView = [[ICDMaterialCircularProgressView alloc]initWithFrame:CGRectMake(140, 140, 40, 40)];
    [self.progressView beginAnimation];
    [self.view addSubview:self.progressView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
