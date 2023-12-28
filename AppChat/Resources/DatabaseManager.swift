//
//  DatabaseManager.swift
//  AppChat
//
//  Created by mahmoud on 07/11/2023.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
}

// MARK: - Account Management

extension DatabaseManager {
    
    func userExists(email: String ,completion: @escaping ((Bool)-> Void)) {
        database.child(email).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else{
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    /// puts new user in database
    public func insertUser(with user : chatAppUser){
        database.child(user.emailAdress).setValue([
            "firstName" : user.firstName,
            "lastName" : user.lastName
        ])
    }
}

struct chatAppUser{
    let firstName : String
    let lastName : String
    let emailAdress : String
    
}
