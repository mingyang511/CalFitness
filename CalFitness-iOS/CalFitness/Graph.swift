//
//  Graph.swift
//  CalFitness
//
//  Created by Siddharth Vanchinathan on 4/15/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Graph : UIView {
    // properties, methods such as `drawRect:`, etc., go here
    
    init (frame : CGRect, records: NSArray) {
        super.init(frame : frame)
        
        //Get maximum
        var myMax: Float = 0.0
        for i in 0...records.count-1 {
            let record = records.objectAtIndex(i) as! NSArray
            if let step = record[0] as? Float {
                if (step > myMax){
                    myMax = step
                }
            }
            if let goal = record[1] as? Float {
                if (goal > myMax){
                    myMax = goal
                }
            }
        }
        
        if myMax == 0 {
            myMax = 100
        }
        
        //Add sections
        for i in 0...records.count-1 {
            let record = records[i] as! NSArray
            if let step = record[0] as? Float {
                if let goal = record[1] as? Float {
                    if let date =  record[2] as? NSDate {
                        let container: GraphBar = GraphBar(
                            frame:CGRectMake(CGFloat(i)*frame.size.width/7.0,0,frame.size.width/7.0, frame.size.height),
                            goalData: goal,
                            stepsData: step,
                            max: myMax,
                            date:date)
                        self.addSubview(container)
                    }
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
