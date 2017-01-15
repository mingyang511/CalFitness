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
            configuration.server = SashidoServer
            configuration.applicationId = SashidoAppId
            configuration.clientKey = SashidoClientKey
            
        }))
    }
    
    func fetchData (){
        CFStore.fetchRecordsFromServer();
        CFStore.fetchConfigFromServer();
        CFStore.fetchUserFromServer();
    }
}
