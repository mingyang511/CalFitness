//
//  GraphBar.swift
//  CalFitness
//
//  Created by Siddharth Vanchinathan on 4/22/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import Foundation
import UIKit

let baseHeight = CGFloat(30.0)
let barMargin = CGFloat(4.0)
let goalThickness = CGFloat(2.0)

let yellowColor = UIColor(red: 253.0/255.0, green: 197.0/255.0, blue: 66.0/255.0, alpha: 1.0)
let greenColor = UIColor(red: 0.0/255.0, green: 197.0/255.0, blue: 66.0/255.0, alpha: 1.0)
let redColor = UIColor(red: 253.0/255.0, green: 0.0/255.0, blue: 66.0/255.0, alpha: 1.0)
let blueColor = UIColor(red: 6.0/255.0, green: 29.0/255.0, blue: 65.0/255.0, alpha: 1.0)

class GraphBar : UIView {
    // properties, methods such as `drawRect:`, etc., go here
    
    init (frame : CGRect, goalData: Float, stepsData: Float, max: Float, date: NSDate) {
        super.init(frame : frame)
        
        let height = frame.size.height - baseHeight
        let barHeight = CGFloat(stepsData/max) * CGFloat(height)
        let goalHeight = CGFloat(goalData/max) * CGFloat(height)
        
        let goal: UIView = UIView(frame:CGRectMake(barMargin,height - goalHeight-goalThickness,frame.size.width - 2*barMargin, goalThickness))
        goal.backgroundColor = blueColor
        
        let goalBar: UIView = UIView(frame:CGRectMake(barMargin,height - goalHeight,frame.size.width - 2*barMargin, goalHeight))
        goalBar.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.2)
        
        let bar: UIView = UIView(frame:CGRectMake(barMargin,height - barHeight,frame.size.width - 2*barMargin, barHeight))
        let barNumber: UILabel = UILabel(frame:CGRectMake(barMargin,height - barHeight-15, frame.size.width - 2*barMargin, 15))
        barNumber.text = String(Int(stepsData))
        barNumber.font = barNumber.font.fontWithSize(9)
        barNumber.textAlignment = NSTextAlignment.Center;
        barNumber.textColor = blueColor
        
        //Add colors to bar
        var barColor: UIColor
        if (goalData <= stepsData){
            barColor = greenColor
        } else {
            barColor = redColor
        }
        bar.backgroundColor = barColor
        barNumber.backgroundColor = UIColor.clearColor()
        
        
        let base: UIView = UIView(frame:CGRectMake(barMargin,height,frame.size.width - 2*barMargin, baseHeight))
        base.backgroundColor = blueColor
        
        let nameFormatter  = NSDateFormatter()
        nameFormatter.dateFormat = "EE"
        let name = nameFormatter.stringFromDate(date)
        
        let topLabel: UILabel = UILabel(frame:CGRectMake(0,0,base.frame.size.width, baseHeight/2.0))
        topLabel.text = String(name)
        topLabel.font = topLabel.font.fontWithSize(10)
        topLabel.textAlignment = NSTextAlignment.Center;
        topLabel.textColor = yellowColor
        
        let dayMonthFormatter  = NSDateFormatter()
        dayMonthFormatter.dateFormat = "MM/dd"
        let dayMonth = dayMonthFormatter.stringFromDate(date)
        
        let bottomLabel: UILabel = UILabel(frame:CGRectMake(0,baseHeight/2.0,base.frame.size.width, baseHeight/2.0))
        bottomLabel.text = String(dayMonth)
        bottomLabel.font = bottomLabel.font.fontWithSize(10)
        bottomLabel.textAlignment = NSTextAlignment.Center;
        bottomLabel.textColor = yellowColor
        
        self.addSubview(goalBar)
        self.addSubview(bar)
        self.addSubview(goal)
        self.addSubview(barNumber)
        self.addSubview(base)
        base.addSubview(topLabel)
        base.addSubview(bottomLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
