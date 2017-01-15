//
//  HomeViewController.swift
//  CalFitness
//
//  Created by Siddharth Vanchinathan on 4/1/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import UIKit
import Parse
import Bolts

class HomeViewController: UIViewController, HealthDelegate {

    @IBOutlet var stepsTodayLabel: LTMorphingLabel!
    @IBOutlet var historyButton: UIButton!
    @IBOutlet var infoButton: UIButton!
    @IBOutlet weak var goalTodayLabel: LTMorphingLabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Set up buttons images
        self.historyButton.setImage(UIImage(named:"graph.png"), forState: .Normal)
        self.historyButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.historyButton.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        self.infoButton.setImage(UIImage(named:"info.png"), forState: .Normal)
        self.infoButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.infoButton.imageEdgeInsets = self.historyButton.imageEdgeInsets 
        
        //Navigation View Controller title colors
        self.navigationController!.navigationBar.tintColor = UIColor(red: 6/255.0, green: 29/255.0, blue: 65/255.0, alpha: 1.0)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        HealthController.sharedInstance.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateView(steps: Int, goal:Int){
        stepsTodayLabel.morphingEffect = .Evaporate
        goalTodayLabel.morphingEffect = .Evaporate
        stepsTodayLabel.text = String(steps)
        if (goal <= 0) {
            goalTodayLabel.text = "NA"
        } else {
            goalTodayLabel.text = String(goal)
        }
    }
}
