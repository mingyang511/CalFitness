//
//  AppDelegate+Parse.swift
//  CalFitnesss
//
//  Created by Lee on 8/27/16.
//  Copyright © 2016 BerkeleyIEOR. All rights reserved.
//

import Foundation
import Parse

extension AppDelegate {
    func registerParse() {
        Parse.enableLocalDatastore()
        Parse.initializeWithConfiguration(ParseClientConfiguration(block: {(configuration:ParseMutableClientConfiguration) -> Void in
            configuration.localDatastoreEnabled = true;
            configuration.server="https://pg-app-uuh60z1arvgpgx2qp0lbsddcgc0iz7.scalabl.cloud/1/"
            configuration.applicationId="iJdpIxC4jBNFkj6eEjNIXKmuToEUFMHaFoSPSzUY"
            configuration.clientKey="N4A0gDqaiOl1YUYbAtMR0Ls8peEPaoYFMFSUUHTM"
            
        }))
    }
    
    func fetchData (){
        CFStore.fetchRecordsFromServer();
        CFStore.fetchConfigFromServer();
        CFStore.fetchUserFromServer();
    }
}
