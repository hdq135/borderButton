//
//  borderButtonView.swift
//  borderButton_swift
//
//  Created by hdq on 15-3-21.
//  Copyright (c) 2015年 hdq. All rights reserved.
//

import UIKit


class borderButtonView : UIView {
    var _type:BBBarType = BBBarType.None;
    
    init(rect:CGRect,type:BBBarType){
        _type = type;
        super.init(frame: rect);
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func moveHorizontal(horizontal:CGFloat, vertical:CGFloat)
    {
        var origionRect = self.frame;
        var newRect = CGRectMake(origionRect.origin.x + horizontal, origionRect.origin.y + vertical, origionRect.size.width, origionRect.size.height);
        self.frame = newRect;
    }
    
    func moveHorizontal(horizontal:CGFloat ,vertical:CGFloat, widthAdded:CGFloat, heightAdded:CGFloat)
    {
        var origionRect = self.frame;
        var newRect = CGRectMake(origionRect.origin.x + horizontal,
        origionRect.origin.y + vertical,
        origionRect.size.width + widthAdded,
        origionRect.size.height + heightAdded);
        self.frame = newRect;
    }
    
    func moveToHorizontal(horizontal:CGFloat, vertical:CGFloat)
    {
        var origionRect = self.frame;
        var newRect = CGRectMake(horizontal, vertical, origionRect.size.width, origionRect.size.height);
        self.frame = newRect;
    }
    
    func moveToHorizontal(horizontal:CGFloat,vertical:CGFloat,width:CGFloat, height:CGFloat)
    {
        var newRect = CGRectMake(horizontal, vertical, width, height);
        self.frame = newRect;
    }
    
    func setWidth(width:CGFloat,height:CGFloat)
    {
        var origionRect = self.frame;
        var newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, width, height);
        self.frame = newRect;
    }
    
    func setWidth(width:CGFloat)
    {
        var origionRect = self.frame;
        var newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, width, origionRect.size.height);
        self.frame = newRect;
    }
    
    func setHeight(height:CGFloat)
    {
        var origionRect = self.frame;
        var newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, origionRect.size.width, height);
        self.frame = newRect;
    }
    
    func addWidth(widthAdded:CGFloat,heightAdded:CGFloat)
    {
        var originRect = self.frame;
        var newWidth = originRect.size.width + widthAdded;
        var newHeight = originRect.size.height + heightAdded;
        var newRect = CGRectMake(originRect.origin.x, originRect.origin.y, newWidth, newHeight);
        self.frame = newRect;
    }
    
    func addWidth(widthAdded:CGFloat)
    {
        self.addWidth(widthAdded,heightAdded: 0);
    
    }
    
    func addHeight(heightAdded:CGFloat)
    {
         self.addWidth(0, heightAdded: heightAdded);
    }
    
    func setCornerRadius(radius:CGFloat)
    {
        self.setCornerRadius(radius,borderColor:UIColor.grayColor());
    }
    
    func setCornerRadius(radius:CGFloat, borderColor:UIColor)
    {
       // self.layer.backgroundColor = UIColor.grayColor().CGColor;
        
        self.layer.borderColor = borderColor.CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = radius;
        self.clipsToBounds = true;
    }
    
    func frameInWindow()->CGRect
    {
        var frameInWindow = self.superview!.convertRect(self.frame, toView: self.window);
        return frameInWindow;
    }
    
    
    func pointInside(point:CGPoint, event:UIEvent)->Bool{
    
        if (_type == BBBarType.None) {
            for view : AnyObject in self.subviews {
                if (CGRectContainsPoint(view.frame,point)) {
                    return true;
                }
            }
            return false;
        }
            
        var rect = self.frame;
        rect.origin = CGPointMake(0, 0);
            
        if (CGRectContainsPoint(rect,point)) {
            return true;
        }
        return false;
    }
    
}