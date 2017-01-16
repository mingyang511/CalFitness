//
//  CFConfigManager.swift
//  CalFitnesss
//
//  Created by Lee on 1/15/17.
//  Copyright © 2017 BerkeleyIEOR. All rights reserved.
//

import Foundation
import Parse

class CFConfigManager
{
    // Method to fetch config from server
    class func fetchConfigFromServer()
    {
        PFConfig.getConfigInBackgroundWithBlock
        {
            (config: PFConfig?, error: NSError?) -> Void in
        }
    }
}
