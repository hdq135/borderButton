//
//  ViewController.m
//  borderButton
//
//  Created by hdq on 15-3-21.
//  Copyright (c) 2015年 hdq. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.bar = [[BBBarController alloc] init:56.0f type:BBBarAll];
    [self.view addSubview:self.bar.view];
    
    for (int i= 0; i<4; i++) {
        
        UIButton* refrsh  = [UIButton buttonWithType:UIButtonTypeSystem];
        [refrsh.layer setCornerRadius:10];
        refrsh.frame = CGRectMake(0, 0, 55, 35);
        [refrsh setTitle:@"Refrsh" forState:UIControlStateNormal];
        // [refrsh setBackgroundColor:[UIColor lightGrayColor]];
        [refrsh addTarget:self action:@selector(refrsh:) forControlEvents:UIControlEventTouchUpInside];
        [self.bar addBarButton:refrsh atBar:BBBarTop];
    }
    [self.bar show:YES];
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *Recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    Recognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:Recognizer];
    Recognizer.delegate = self;
    
    Recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2:)];
    Recognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:Recognizer];
    Recognizer.delegate = self;
}
-(void)saveData{
    [self.bar savetofile];
}
-(void)refrsh:(id)sender{
    
}
-(void)tap:(UILongPressGestureRecognizer*)gestureRecognizer {
    [self.bar show:NO];
}
-(void)tap2:(UILongPressGestureRecognizer*)gestureRecognizer {
    [self.bar show:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
