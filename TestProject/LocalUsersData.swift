//
//  LocalUsersData.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 07.11.23.
//

import Foundation
import CoreData
import UIKit

final class LocalUsersData: NSManagedObject {
//    lazy var persistentContainer: NSPersistentContainer = {
//
//            let container = NSPersistentContainer(name: "Users")
//            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//                if let error = error {
//
//                    fatalError("Unresolved error, \((error as NSError).userInfo)")
//                }
//            })
//            return container
//        }()
    
    private var users: [NSManagedObject] = []
    private var wrappedUsers: [UsersResponseItem] = []
    private var managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "User")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

extension LocalUsersData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalUsersData> {
        return NSFetchRequest<LocalUsersData>(entityName: "User")
    }
    @NSManaged public var id: String?
    @NSManaged public var amount: NSNumber?
    @NSManaged public var bookingDate: String?
    @NSManaged public var category: NSNumber?
    @NSManaged public var currency: String?
    
    @NSManaged public var partnerDisplayName: String?
    @NSManaged public var transactionDetailsDescription: String?
    
    
    public func fetchRequest() async -> [UsersResponseItem]{
        guard let managedContext = managedContext else { return [] }
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            users = try managedContext.fetch(fetchRequest)
            return usersValues
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func saveUser(object: UsersResponseItem) {
        //        guard !wrappedTransactions.contains(where: {$0.alias?.reference == object.alias?.reference}) else { return } -> this is the case when we want to not to have same transaction but because we are removing everything we don't need it.
        guard let managedContext = managedContext else { return }
        let entity =
        NSEntityDescription.entity(forEntityName: "User",
                                   in: managedContext)!
        
        let user = NSManagedObject(entity: entity,
                                          insertInto: managedContext)
        user.setValue(object.id, forKeyPath: "id")
        user.setValue(object.mail, forKeyPath: "mail")
        user.setValue(object.password, forKeyPath: "password")
        user.setValue(object.birthDate, forKeyPath: "birthDate")
        if usersValues.contains(where: {$0.mail == object.mail}) {
            print("arsebobs")
        }
        do {
            try managedContext.save()
            users.append(user)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - this is because we want to update if there is not error, so if response is success we should remove everything
    private func fetchAndRemoveAllObjects() {
        guard let managedContext = managedContext else { return }
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            users = try managedContext.fetch(fetchRequest)
            users.forEach({managedContext.delete($0)})
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private var usersValues: [UsersResponseItem] {
        users.map { obj in
            UsersResponseItem(id: obj.value(forKey: "id") as? String,
                              mail: obj.value(forKey: "mail") as? String,
                              password: obj.value(forKey: "password") as? String,
                              birthDate: obj.value(forKey: "birthDate") as? Date)
        }
    }
}

import Foundation

// MARK: - Welcome
struct UsersResponse: Codable {
    let items: [UsersResponseItem]?
}

// MARK: - Item
struct UsersResponseItem: Codable {
    let id: String?
    let mail: String?
    let password: String?
    let birthDate: Date?
}
