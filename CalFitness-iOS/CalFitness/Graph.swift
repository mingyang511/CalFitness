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
    
    init (frame : CGRect, records: [CFRecord]) {
        super.init(frame : frame)
        
        //Get maximum
        var myMax: Float = 0.0
        for i in 0...records.count-1 {
            let record = records[i]
            if (record.step > myMax){
                myMax = record.step
            }
            
            if (record.goal > myMax){
                myMax = record.goal
            }
        }
        
        if myMax == 0 {
            myMax = 100
        }
        
        //Add sections
        for i in 0...records.count-1 {
            let record = records[i]
            let container: GraphBar = GraphBar(
                frame:CGRectMake(CGFloat(i)*frame.size.width/7.0,0,frame.size.width/7.0, frame.size.height),
                goalData: record.goal,
                stepsData: record.step,
                max: myMax,
                date:CFDateHelper.getDate(record.date))
            self.addSubview(container)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
