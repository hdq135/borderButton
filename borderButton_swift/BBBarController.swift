//
//  BBBarController.swift
//  borderButton_swift
//
//  Created by hdq on 15-3-21.
//  Copyright (c) 2015年 hdq. All rights reserved.
//

import UIKit


struct BBBarType : RawOptionSetType,Hashable {
    typealias RawValue = UInt
    private var value: UInt = 0
    var rawValue: UInt { return self.value }
    init(rawValue value: UInt) { self.value = value }
    init(_ value: UInt) { self.value = value }
    init(nilLiteral: ()) { self.value = 0 }
    static var allZeros: BBBarType { return self(0) }
    static func fromMask(raw: UInt) -> BBBarType { return self(raw) }
    static var None: BBBarType { return self(0) }
    static var Top: BBBarType { return self(1 << 0) }
    static var Left: BBBarType { return self(1 << 1) }
    static var Right: BBBarType { return self(1 << 2) }
    static var Bottom: BBBarType { return self(1 << 3) }
    static var All: BBBarType { return self(0xf) }
    static let ALLValues = [Top,Left,Right,Bottom]
    var hashValue: Int { return "\(self.value)".hashValue }
}
let BBFILENAME = "bbarmaps.plist"
let BBBUTTONTAG = 100
class BBBarController: UIViewController,UIGestureRecognizerDelegate {
    
    var time:CGFloat = 0.00;
    var step:CGFloat = 0;
    var lenth:CGFloat = 0.0;
    var CurrentLenth:CGFloat = 0.00;
    
    var timer:NSTimer?;
    
    var barType:BBBarType = BBBarType.All;
    var bars:Dictionary<BBBarType, borderButtonView>=[:];
    var maps:NSMutableDictionary?;
    
    var oldButtonSuperView:borderButtonView?;
    var currentButton:UIButton?;

    init(lenth:CGFloat,type:BBBarType=BBBarType.All){
        super.init();
        self.lenth = lenth;
        self.step = -1;
        self.time = 0.5;
        self.barType = type;
        
    }
    override init(nibName nibNameorNil:String?,bundle nibBundleOrNil:NSBundle?){
        super.init(nibName:nibNameorNil,bundle:nibBundleOrNil)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
    }
    
    override func loadView() {
        var applicationFrame = UIScreen.mainScreen().bounds;
        self.view = borderButtonView(rect: applicationFrame, type: BBBarType.None);
        
        var width = applicationFrame.size.width - 2*self.lenth;
        var hight = applicationFrame.size.height - 2*self.lenth;
        var rect:CGRect?;
        for i in BBBarType.ALLValues{
            if i&self.barType == i {
                switch(i&self.barType){
                case BBBarType.Top:
                    rect = CGRectMake(self.lenth ,0,width, self.lenth);
                    break;
                case BBBarType.Left:
                    rect = CGRectMake(0, self.lenth, self.lenth, hight);
                    break;
                case BBBarType.Right:
                    rect = CGRectMake(applicationFrame.size.width - self.lenth,self.lenth, self.lenth, hight);
                    break;
                case BBBarType.Bottom:
                    rect = CGRectMake(self.lenth,applicationFrame.size.height - self.lenth,width, self.lenth);
                    break;
                default:
                    continue;
                }
                self.bars.updateValue(borderButtonView(rect: rect!, type: i), forKey: i);
                self.view.addSubview(self.bars[i]!);
            }
        }
        if(!self.readDate()){
            self.maps = NSMutableDictionary();
        }
        self.setCornerRadius(8.0);
        self.setBackgroundColor(0.7, alphas: 0.5);
        self.CurrentLenth = 0;
        
        
        var Recognizer = UIPanGestureRecognizer(target: self, action: "pan:");
        self.view.addGestureRecognizer(Recognizer);
        
        Recognizer.delegate = self;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(animated:Bool)
    {
        if ((self.timer) != nil) {
            self.timer?.fireDate = NSDate.distantPast() as NSDate;
        }
    }
        
    override func viewDidDisappear(animated:Bool)
    {
        if ((self.timer) != nil) {
            self.timer?.fireDate = NSDate.distantFuture() as NSDate;
        }
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func show(on:Bool){
        if ((self.timer) != nil) {
            return;
        }
        if (on) {
            self.step = self.step > 0 ? self.step : 0 - self.step;
        }
        else{
            self.step = self.step < 0 ? self.step : 0 - self.step;
        }
        
        var time = self.time/self.lenth/(self.step>0 ? self.step : 0-self.step);
        self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(time), target: self, selector: "timerAction:", userInfo: nil, repeats: true);
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }
    
// MARK: - button
    
    func addBarButton(objects:UIButton, type:BBBarType)->Int{
        var view:borderButtonView?;
        var t = self.barType & type;
        if(t != BBBarType.None && t == type){
             view = self.bars[t];
        }
        else{
            for i in BBBarType.ALLValues{
                if(i & self.barType == i){
                    t = i;
                    view = self.bars[i];
                    break;
                }
            }
        }
        if (view == nil) {
            return -1;
        }
        
        var count:Int = 0;
        for i in BBBarType.ALLValues{
            if(i & self.barType == i) {
                var view = self.bars[i];
                count += (view?.subviews.count)!;
            }
        }
        objects.tag = count+BBBUTTONTAG;
        var index = BBBarType.None;
        
        for i in BBBarType.ALLValues{
            if let tags: NSArray  = (self.maps?.objectForKey(String(i.value))) as? NSArray{
                if(i & self.barType == i ) {
                    for j in 0..<tags.count {
                        if(objects.tag == tags[j].integerValue){
                            index = i;
                            break;
                        }
                    }
                }
            }
        }
        
        if (index == BBBarType.None) {
            if let tags: NSMutableArray =  self.maps?.objectForKey(String(view!._type.value)) as? NSMutableArray{
                tags.addObject(NSNumber(integer:objects.tag));
            }else{
                self.maps?.setObject(NSMutableArray(object: NSNumber(integer: objects.tag)), forKey: String(view!._type.value));
            }
            view?.addSubview(objects);
            self.orderButton(view!._type);
        }else{
            var v = self.bars[index];
            v?.addSubview(objects);
            self.orderButton(index);
        }
    
        objects.addTarget(self, action: "dragInside:", forControlEvents: UIControlEvents.TouchDragInside);
        return objects.tag;
    }
    func orderButton(type:BBBarType){
        var view = self.bars[type];
        if let array: NSArray = self.maps?.objectForKey(String(type.value)) as? NSArray{
            if(view?.subviews.count == 0){
                return;
            }
            
            var width = view?.frame.size.width>0 ? view?.frame.size.width : self.lenth;
            var height = view?.frame.size.height>0 ? view?.frame.size.height : self.lenth;
            
            for (var i=0,j=0 as Int; i < array.count; i++) {
                var button = view?.viewWithTag(array[i].integerValue);
                if (button == nil) {
                    continue;
                }
            
                var x = width!/2;
                var y = (height!/(CGFloat(view!.subviews.count)+1.0))*(CGFloat(j)+1.0);
            
                switch (view!._type) {
                    case BBBarType.Top:
                        x = (width!/(CGFloat(view!.subviews.count)+1))*(CGFloat(j)+1);
                        y = height!/2 ;
                        break;
                    case BBBarType.Bottom:
                        x = (width!/(CGFloat(view!.subviews.count)+1))*(CGFloat(j)+1);
                        y = height!/2 ;
                        break;
                    case BBBarType.Left:
                         x = width!/2;
                         y = (height!/(CGFloat(view!.subviews.count)+1.0))*(CGFloat(j)+1.0);
                            break;
                    case BBBarType.Right:
                         x = width!/2;
                         y = (height!/(CGFloat(view!.subviews.count)+1.0))*(CGFloat(j)+1.0);
                        break;
                    default:
                        break;
                }
                button!.center = CGPointMake(x, y);
                j++;
            }
        }
    }
    
    func orderButton(){
        if let dict:Dictionary = self.maps {
            for key in dict.keys {
                var type:BBBarType = BBBarType(UInt(key.description.toInt()!))
                if (type&self.barType == type) {
                    self.orderButton(type);
                }
            }
        }
    }
    func refrashArray(type:BBBarType,tag:Int){
        if let array: NSMutableArray = self.maps?.objectForKey(String(type.value)) as? NSMutableArray{
            for (var i = 0; i<array.count; i++) {
                if (array[i].integerValue == -1) {
                    if (tag == -1) {
                        array.removeObjectAtIndex(i);
                    }else{
                        array.replaceObjectAtIndex(i,withObject:NSNumber(integer: tag));
                    }
                    break;
                }
            }
        }
    }
    func moveTo(view:borderButtonView, index:Int){
    
        self.currentButton?.removeFromSuperview();
        view.addSubview(self.currentButton!);
        
        if let array: NSMutableArray = self.maps?.objectForKey(String(view._type.value)) as? NSMutableArray{
            if (index == -1) {
                self.refrashArray(view._type, tag: self.currentButton!.tag);
            }else if(index < array.count){
                array.insertObject(NSNumber(integer: self.currentButton!.tag), atIndex: index);
                self.refrashArray(self.oldButtonSuperView!._type, tag: -1);
            }else{
                array.addObject(NSNumber(integer: self.currentButton!.tag));
                self.refrashArray(self.oldButtonSuperView!._type,tag:-1);
            }
        }else{
            self.maps?.setObject(NSMutableArray(object: NSNumber(integer: self.currentButton!.tag)), forKey: String(view._type.value));
            self.refrashArray(self.oldButtonSuperView!._type,tag:-1);
        }
        
        self.orderButton(view._type);
        self.currentButton = nil;
        self.oldButtonSuperView = nil;
        self.setCurrentLenth(self.CurrentLenth);
    }
    
// MARK: – save
    
    func savetofile(){
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        var documentsDirectory: AnyObject = paths[0];
        var  path = documentsDirectory.stringByAppendingString(BBFILENAME);
         self.maps?.writeToFile(path, atomically: true);
    }
    func readDate()->Bool{
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        var documentsDirectory: AnyObject = paths[0];
        var  path = documentsDirectory.stringByAppendingString(BBFILENAME);
        
        if (NSFileManager.defaultManager().fileExistsAtPath(path)) {
            self.maps = NSMutableDictionary(contentsOfFile: path);
            return true;
        }
            return false;
    }
    
// MARK: –style
    
    func setCurrentLenth(lenth:CGFloat, All:Bool = false){
        for i in BBBarType.ALLValues{
            if(i & self.barType == i){
                var view = self.bars[i];
                var rect = view?.frame;
                if (view?.subviews.count > 0 || All){
                    switch(i){
                        case BBBarType.Top:
                            view?.setHeight(lenth);
                            break;
                        case BBBarType.Left:
                            view?.setWidth(lenth);
                            break;
                        case BBBarType.Right:
                            rect?.origin.x = self.view.frame.size.width - lenth;
                            rect?.size.width = lenth;
                            view?.frame = rect!;
                            break;
                        case BBBarType.Bottom:
                            rect?.origin.y = self.view.frame.size.height - lenth;
                            rect?.size.height = lenth;
                            view?.frame = rect!;
                            break;
                        default:
                            break;
                    }
                }else if(!All){
                    switch(i){
                        case BBBarType.Top:
                            view?.setHeight(0);
                            break;
                        case BBBarType.Left:
                            view?.setWidth(0);
                            break;
                        case BBBarType.Right:
                            rect?.origin.x = self.view.frame.size.width;
                            rect?.size.width = 0;
                            view?.frame = rect!;
                            break;
                        case BBBarType.Bottom:
                            rect?.origin.y = self.view.frame.size.height;
                            rect?.size.height = 0;
                            view?.frame = rect!;
                            break;
                        default:
                            break;
                    }
                }
            }
        }
        self.CurrentLenth = lenth;
    }


    func setCornerRadius(radius:CGFloat){
        for i in BBBarType.ALLValues{
            if(i & self.barType == i){
                var view = self.bars[i];
                view?.setCornerRadius(radius);
            }
        }
    }
    
    func setCornerRadius(radius:CGFloat, borderColor:UIColor){
        for i in BBBarType.ALLValues{
            if(i & self.barType == i){
                var view = self.bars[i];
                view?.setCornerRadius(radius,borderColor:borderColor);
            }
        }
    }
    func setBackgroundColor(color:CGFloat, alphas:CGFloat){
        for i in BBBarType.ALLValues{
            if(i & self.barType == i){
                var view = self.bars[i];
                view?.backgroundColor = UIColor(white: color, alpha: alphas);
            }
        }
    }

    
// MARK: - backcall
   
    
    func timerAction(timer:AnyObject){            //timer
        if ((self.CurrentLenth >= self.lenth && self.step>0 ) || (self.CurrentLenth <= 0 && self.step<0)) {
            timer.invalidate();
            self.timer = nil;
            self.CurrentLenth = self.step>0 ? self.lenth : 0;
            self.setCurrentLenth(self.CurrentLenth);
            return;
        }
        self.CurrentLenth += self.step;
        self.setCurrentLenth(self.CurrentLenth);
    }
    
    func pan(pan:UIPanGestureRecognizer) {   //PanGestureRecognizer
        
        if (self.currentButton == nil) {
            return;
        }
        switch (pan.state) {
            case UIGestureRecognizerState.Began:
                self.setCurrentLenth(self.lenth, All: true);
                var view:borderButtonView  = self.currentButton!.superview as borderButtonView;
                var p = CGPointMake(self.currentButton!.center.x + view.frame.origin.x,self.currentButton!.center.y + view.frame.origin.y);
                self.oldButtonSuperView = self.currentButton!.superview as? borderButtonView;
                self.currentButton?.removeFromSuperview();
                self.view.addSubview(self.currentButton!);
                self.currentButton!.center = p;
                if let array: NSMutableArray = self.maps?.objectForKey(String(view._type.value)) as? NSMutableArray{
                    for i in 0..<array.count {
                        if array[i].integerValue == self.currentButton?.tag {
                            array.replaceObjectAtIndex(i, withObject: NSNumber(integer: -1));
                        }
                    }
                }
                self.orderButton(view._type);
                break;
            case UIGestureRecognizerState.Changed:
                if ((self.currentButton) != nil) {
                    var translation = pan.translationInView(self.view);
                    self.currentButton!.center = CGPointMake(self.currentButton!.center.x + translation.x, self.currentButton!.center.y + translation.y);
                    pan.setTranslation(CGPoint(x: 0,y: 0), inView: self.view);
                }
                break;
            case UIGestureRecognizerState.Ended:
                var point = self.currentButton!.center;
                
                for i in BBBarType.ALLValues {
                    if(i&self.barType == i){
                        var view:borderButtonView = self.bars[i]!;
                        if CGRectContainsPoint(view.frame,point) {
                            if let array: NSMutableArray = self.maps?.objectForKey(String(view._type.value)) as? NSMutableArray{
                                var index = -1;
                                if view._type == BBBarType.Left || view._type == BBBarType.Right {
                                    var l:CGFloat = view.frame.size.height/CGFloat((array.count+1));
                                    index = Int((point.y - self.lenth)/l);
                                    
                                }else{
                                    var l:CGFloat = view.frame.size.width/CGFloat((array.count+1));
                                    index = Int((point.x - self.lenth)/l);
                                    
                                }
                                self.moveTo(view, index: index);
                            }else{
                                self.moveTo(view, index: 0);
                            }
                        }
                    }
                }
                if (self.currentButton != nil) {
                    self.moveTo(self.oldButtonSuperView!, index:-1);
                }
                break;
            case UIGestureRecognizerState.Cancelled:
                if (self.currentButton != nil) {
                    self.moveTo(self.oldButtonSuperView!, index:-1);
                }
                break;
            case UIGestureRecognizerState.Failed:
                NSLog("uigesture fail");
                break;
            default:
                break;
        }
    }
    
    
    func dragInside(sender:AnyObject)  //button draginside
    {
        self.currentButton = (sender as UIButton);
    }
    
    func orientationDidChange(note:NSNotification)   //Rotate screen
    {
        
        
        var mainRect = UIScreen.mainScreen().bounds;
        var width = mainRect.size.width - 2*self.lenth;
        var hight = mainRect.size.height - 2*self.lenth;
        var rect = CGRectMake(self.lenth ,0,width, self.CurrentLenth );
        self.view.frame = mainRect;
        for i in BBBarType.ALLValues{
            if(i & self.barType == i){
                var view = self.bars[i];
                switch(i){
                    case BBBarType.Top:
                        rect = CGRectMake(self.lenth ,0,width, self.CurrentLenth );
                        break;
                    case BBBarType.Left:
                        rect = CGRectMake(0, self.lenth, self.CurrentLenth , hight);
                        break;
                    case BBBarType.Right:
                        rect = CGRectMake(mainRect.size.width - self.lenth,self.lenth, self.CurrentLenth , hight);
                        break;
                    case BBBarType.Bottom:
                        rect = CGRectMake(self.lenth,mainRect.size.height - self.lenth,width, self.CurrentLenth );
                        break;
                    default:
                        break;
                }
                view?.frame = rect;
                self.orderButton(i);
            }
        }
        self.setCurrentLenth(self.CurrentLenth);
    }
}
