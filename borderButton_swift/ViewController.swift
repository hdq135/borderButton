//
//  ViewController.swift
//  borderButton_swift
//
//  Created by hdq on 15-3-21.
//  Copyright (c) 2015年 hdq. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var bar:BBBarController = BBBarController(lenth: 50, type: BBBarType.All)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(bar.view);
        
        var refrsh:UIButton  = UIButton.buttonWithType(UIButtonType.System) as UIButton;
        refrsh.layer.cornerRadius = 10;
        refrsh.frame = CGRectMake(0, 0, 55, 35);
        refrsh.setTitle("Refrsh", forState:UIControlState.Normal);
        // [refrsh setBackgroundColor:[UIColor lightGrayColor]];
        bar.addBarButton(refrsh ,type:BBBarType.Top);
        
        var Recognizer = UITapGestureRecognizer(target: self, action: "tap:");
        Recognizer.numberOfTapsRequired = 1;
        self.view.addGestureRecognizer(Recognizer);
        Recognizer = UITapGestureRecognizer(target: self, action: "tap:");
        Recognizer.numberOfTapsRequired = 2;
        self.view.addGestureRecognizer(Recognizer);
        
        bar.show(true);
        Recognizer.delegate = self;
    }
    func tap(tap:UITapGestureRecognizer){
        if tap.state == UIGestureRecognizerState.Ended {
            bar.show(tap.numberOfTapsRequired == 2);
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

