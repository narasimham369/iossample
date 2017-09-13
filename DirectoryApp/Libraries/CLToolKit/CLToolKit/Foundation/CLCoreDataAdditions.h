//
//  CLCoreDataAdditions.h
//  <Generic>
//
//
//  Copyright (c) 2013 CodeLynks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#pragma mark - NSManagedObjectContext + Additions

@interface NSManagedObjectContext (Additions)

+(NSManagedObjectContext *)newContextForPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;
@end

#pragma mark

@interface CLCoreDataAdditions : NSObject     {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property(nonatomic, strong) NSURL *modelURL;
@property(nonatomic, strong) NSURL *storeURL;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark - Interfaces

+ (CLCoreDataAdditions *)sharedInstance;
- (void)refreshObject:(NSManagedObject *)managedObject;
- (void)resetContext;
- (id)entityForName:(NSString *)entityName;
- (id)newEntityForName:(NSString *)entityName;
- (void)deleteObject:(NSManagedObject *)object;
- (BOOL)saveEntity;
- (NSArray *)getAllDocuments:(NSString *)entity;
- (NSArray *)getAllDocuments:(NSString *)entity withOrder:(NSString *)orderKey whetherAscending:(BOOL)whetherAscending;
- (NSArray *)getAllDocumentsFor:(NSString *)entity withPredicate:(NSPredicate *)predicate;
- (NSArray *)getAllDocuments:(NSString *)entity sortByKey:(NSString *)key withPredicate:(NSPredicate *)predicate whetherAscendingOrder:(BOOL) whetherAscending;
- (void)deleteAllEntities:(NSString *)nameEntity;

@end
