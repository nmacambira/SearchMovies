//
//  NMRealmDatabaseAssistant.swift
//  NMRealmDatabaseAssistant
//
//  Created by Natalia Macambira on 30/04/17.
//  Copyright © 2017 Natalia Macambira. All rights reserved.
//

import RealmSwift

class NMRealmDatabaseAssistant {
    
    static let realm = try! Realm()
    
    //MARK: - Object exist    
    static func objectExist <T: RealmSwift.Object>(id: Int, inEntity entity: T.Type) -> Bool {
        return realm.object(ofType: entity, forPrimaryKey: id) != nil
    }
    
    //MARK: - Save objects
    static func save(object: Object) {
        do {
            try realm.write {
                realm.add(object, update: true)
            }
        } catch {
            print("Could not save object!")
        }
    }
    
    static func saveAll(objects: [Object]) {
        do {
            try realm.write {
                realm.add(objects, update: true)
            }
        } catch {
            print("Could not save all objects!")
        }
    }
    
    //MARK: - Delete objects
    static func delete(object: Object) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("Could not delete object!")
        }
    }
    
    static func deleteAllObjectsFrom(entity: Object.Type) {
        do {
            try realm.write {
                realm.delete(realm.objects(entity))
            }
        } catch {
            print("Could not delete all objects!")
        }
    }
    
    //MARK: - Querys
    static func queryForAnArrayOf<T: RealmSwift.Object>(entity: T.Type, sortedByKeyPath keyPath: String?) -> Array<T>? {
        if keyPath != nil {
            return Array(realm.objects(entity).sorted(byKeyPath: keyPath!, ascending: true))
        } else {
            return Array(realm.objects(entity))
        }
    }
    
    static func queryForAnArrayOf<T: RealmSwift.Object>(entity: T.Type, withPredicate predicate: NSPredicate, sortedByKeyPath keyPath: String?) -> Array<T>? {
        if keyPath != nil {
            return Array(realm.objects(entity).filter(predicate).sorted(byKeyPath: keyPath!, ascending: true))
        } else {
            return Array(realm.objects(entity).filter(predicate))
        }
    }
    
    static func queryForSingleObjectFrom<T: RealmSwift.Object>(entity: T.Type) -> T? {
        let result = realm.objects(entity)
        return result.first
    }
    
    static func queryForSingleObjectFrom<T: RealmSwift.Object>(entity: T.Type, withIdentifier id: Int) -> T? {
        let result = realm.objects(entity).filter("identifier == %d", id)
        return result.first
    }
    
    static func queryForSingleObjectFrom<T: RealmSwift.Object>(entity: T.Type, withPredicate predicate: NSPredicate) -> T? {
        let result = realm.objects(entity).filter(predicate)        
        return result.first
    }
    
    //MARK: - Clear database
    ///  Delete all objects from Realm DataBase
    static func clearDataBase() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Could not clear database!")
        }
    }
}
