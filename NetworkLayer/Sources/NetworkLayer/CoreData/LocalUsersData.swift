//
//  LocalUsersData.swift
//  TestProject
//
//  Created by Nato Egnatashvili on 07.11.23.
//

import Foundation
import CoreData
import UIKit

public protocol LocalUsersDataProtocol {
    func fetchAndRemove(id: String)
    func fetchRequest() async -> [UsersResponseItem]
    func saveUser(object: UsersResponseItem) async -> Result<String, ErrorType>
    func getUser(email: String, password: String) async -> Result<String, ErrorType>
}

public final class LocalUsersData: NSManagedObject, LocalUsersDataProtocol {
    private enum Constant {
        static let ContainerName: String = "Users"
        static let ContainerExtension: String = "momd"
        static let EntityName: String = "User"
        static let LocateError: String = "Failed to locate the Core Data model file."
    }
    
    private var users: [NSManagedObject] = []
    private var wrappedUsers: [UsersResponseItem] = []
    private static var persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle.module.url(forResource: Constant.ContainerName,
                                               withExtension: Constant.ContainerExtension),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)  else {
            fatalError(Constant.LocateError)
        }
        let container = NSPersistentContainer(name: Constant.ContainerName,
                                              managedObjectModel: managedObjectModel)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var managedContext: NSManagedObjectContext = persistentContainer.viewContext
}

extension LocalUsersData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalUsersData> {
        return NSFetchRequest<LocalUsersData>(entityName: Constant.EntityName)
    }
    
    private var usersValues: [UsersResponseItem] {
        users.map { obj in
            UsersResponseItem(id: obj.value(forKey: "id") as? String,
                              mail: obj.value(forKey: "mail") as? String,
                              password: obj.value(forKey: "password") as? String,
                              birthDate: obj.value(forKey: "birthDate") as? Date)
        }
    }
    // No need for async but it will be like real service
    @discardableResult
    public func fetchRequest() async -> [UsersResponseItem]{
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: Constant.EntityName)
        
        do {
            users = try managedContext.fetch(fetchRequest)
            return usersValues
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    public func saveUser(object: UsersResponseItem) async -> Result<String, ErrorType> {
        if users == [] { Task { await fetchRequest() } }
        let entity =
        NSEntityDescription.entity(forEntityName: Constant.EntityName,
                                   in: managedContext)!
        
        let user = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        user.setValue(object.id, forKeyPath: "id")
        user.setValue(object.mail, forKeyPath: "mail")
        user.setValue(object.password, forKeyPath: "password")
        user.setValue(object.birthDate, forKeyPath: "birthDate")
        if usersValues.contains(where: {$0.mail == object.mail}) {
            return Result<String, ErrorType>.failure(.error("User already exist"))
        }
        
        do {
            try managedContext.save()
            users.append(user)
            return .success("Success")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return Result<String, ErrorType>.failure(.error("Could not saved"))
        }
    }
    
    public func getUser(email: String, password: String) async -> Result<String, ErrorType> {
      
            let usersValues = await fetchRequest()
            guard let _ = usersValues.filter({$0.mail == email && $0.password == password}).first else {
                return Result<String, ErrorType>.failure(.error("There is not correct mail or passsword"))
            }
            return .success("Success")
    }
    
    private func fetchAndRemoveAllObjects() {
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: Constant.EntityName)
        
        do {
            users = try managedContext.fetch(fetchRequest)
            users.forEach({managedContext.delete($0)})
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    public func fetchAndRemove(id: String) {
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: Constant.EntityName)
        
        do {
            users = try managedContext.fetch(fetchRequest)
            for obj in users {
                let name = obj.value(forKey: "id") as? String
                if name == id {
                    managedContext.delete(obj)
                    try managedContext.save()
                    break
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

