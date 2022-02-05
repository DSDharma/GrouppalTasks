//
//  AppDelegate.swift
//  Tasks
//
//  Created by Dharma on 05/02/22.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let realmSchemaVersion: UInt64 = 2
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        ///Initialize realm database
        self.createRealmDatabase()
        
        return true
    }
    
}

extension AppDelegate {
    
    //MARK:- Create realm database with Configuration
    func createRealmDatabase(){
        Realm.Configuration.defaultConfiguration = self.configForRealm() // new configuration object for the default Realm
        do {
            _ = try Realm()
            print("Database created successfully @\(Realm.Configuration.defaultConfiguration.fileURL!)")
        } catch let error as NSError {
            print("Error to create database - \(error)")
        }
    }
    
    /// Configuration for Relam
    func configForRealm() -> Realm.Configuration{
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: self.realmSchemaVersion,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < self.realmSchemaVersion) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })
        
        return config
    }
}

