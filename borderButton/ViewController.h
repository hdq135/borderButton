//
//  ViewController.h
//  borderButton
//
//  Created by hdq on 15-3-21.
//  Copyright (c) 2015年 hdq. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBBarController.h"
@interface ViewController : UIViewController <UIGestureRecognizerDelegate>
-(void)saveData;
@property (strong,nonatomic) BBBarController *bar;
@end

