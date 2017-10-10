

//
//  CLCoreDataAdditions.m
//  <Generic>
//
//  .
//  Copyright (c) 2013 Codelynks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCoreDataAdditions.h"

#define kManagedObjectContextKey @"NSManagedObjectContextForThreadKey"

#pragma mark - NSManagedObjectContext + Additions

@implementation NSManagedObjectContext (Additions)

+(NSManagedObjectContext *)newContextForPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator  {
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator: coordinator];
    [context setMergePolicy:NSOverwriteMergePolicy];
    return context;
}

@end

#pragma mark - CoreData + Additions

@implementation CLCoreDataAdditions

@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize modelURL = _modelURL;
@synthesize storeURL = _storeURL;

+ (CLCoreDataAdditions *)sharedInstance
{
    static CLCoreDataAdditions *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CLCoreDataAdditions alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

#pragma mark - Overriden

-(void)setManagedObjectContext:(NSManagedObjectContext *)context   {
	if ([NSThread isMainThread])    {
        _managedObjectContext = nil;
		_managedObjectContext = context;
	}
    else    {
        //NSLog(@"\n Exception on setManagedObjectContext : setManagedObjectContext works only when calling through mainThread....");
    }
}

#pragma mark - Private Methods

- (NSString *)defaultDatabaseDirectory {
   // NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
   NSString *appName=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
   NSString *defaultDatabaseDirectory = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/Database",appName]];
    
    return defaultDatabaseDirectory;
}

-(void)createIntermediateDirectory  {
    NSURL *directoryPath = [self.storeURL URLByDeletingLastPathComponent];
    NSError *error;
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:directoryPath includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:&error];
    if (!array) {
        
        if (![[NSFileManager defaultManager] createDirectoryAtURL:directoryPath withIntermediateDirectories:YES attributes:nil error:&error]) {
           // NSLog(@"\n Error Occured While creating Intermediate Directory : %@",[error description]);
        }
    }
}

#pragma mark - 

-(NSManagedObjectModel *)managedObjectModel    {
    @try {
        if (managedObjectModel != nil)  {
            return managedObjectModel;
        }
        
        self.modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        //NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
        
               if (!self.modelURL) {
            //NSLog(@"\n Exception on managedObjectModel : Data Model Name Not Found....");
            [NSException raise:@"L7CoreDataAdditions" format:@"Data Model Not Found"];
        }
        
        BOOL isMultitaskingSupported = NO;
        if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])   {
            isMultitaskingSupported = [(id)[UIDevice currentDevice] isMultitaskingSupported];
        }
        if (isMultitaskingSupported)     {
            managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
        }
        else    {
            managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];     
        }
        
        return managedObjectModel;
    }
    @catch (NSException *exception) {
        //NSLog(@"\n Exception on managedObjectModel : %@",[exception description]);
    }
    @finally {
        
    }
    
    return nil;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator    {	
    @try {
        
        if (persistentStoreCoordinator != nil) {
            return persistentStoreCoordinator;
        }
        
        if (!self.storeURL) {
           // NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
            NSString *dataStoreName = [NSString stringWithFormat:@"ribbn.sqlite"];
            
            self.storeURL = [NSURL fileURLWithPath: [[self defaultDatabaseDirectory] stringByAppendingPathComponent:dataStoreName]];
            NSLog(@"\n Data Store URL Not Found - Set to Default Store URL : %@",self.storeURL);
        }
        
        [self createIntermediateDirectory];
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        NSError *error = nil;
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] 
                                      initWithManagedObjectModel:[self managedObjectModel]];
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
                                                      configuration:nil
                                                                URL:self.storeURL
                                                            options:options
                                                              error:&error]) {
            //NSLog(@"\n Error unresolved error while creating Persistent Store Coordinator \n %@, %@ \n Aborting....", error, [error userInfo]);
            abort();
        } 
        else    {
            //NSLog(@"\n Create a Persistent Store Coordinator Sucessfully.... \n Coordinator : %@",persistentStoreCoordinator);
        }
        
        
        return persistentStoreCoordinator;
    }
    @catch (NSException *exception) {
       // NSLog(@"\n Exception on persistentStoreCoordinator : %@",[exception description]);
    }
    @finally {
        
    }
    
    return nil;
}

#pragma mark - Observers    

- (void)startObserveContext:(NSManagedObjectContext *)context   {
    //NSLog(@"Start Observing Context : %@",context);
	[[NSNotificationCenter defaultCenter]   addObserver:self    
                                               selector:@selector(mergeChanges:)
                                                   name:NSManagedObjectContextDidSaveNotification
                                                 object:context];
}

- (void)stopObservingContext:(NSManagedObjectContext *)context {
    //NSLog(@"Stop Observing Context : %@",context);
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSManagedObjectContextDidSaveNotification
												  object:context];
}

#pragma mark - Context

-(NSManagedObjectContext*)managedObjectContextForMain     {
    return managedObjectContext;
}

-(NSManagedObjectContext*)managedObjectContext  {
    NSManagedObjectContext *context = nil;
	
    if ([NSThread isMainThread])    {
        if (!_managedObjectContext)  {
            NSManagedObjectContext *mainContext = [NSManagedObjectContext newContextForPersistentStoreCoordinator:[self persistentStoreCoordinator]];
            //NSLog(@"\n Create New Context : %@ \n For Main Thread : %@",context,[NSThread currentThread]);
            [self setManagedObjectContext:mainContext];
        }
        
        context = _managedObjectContext;
	}   else    {
        //find context for this thread.
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
		context = [threadDictionary objectForKey:kManagedObjectContextKey];
        
        if (!context)   {
            //create a new context for this thread.
			context = [NSManagedObjectContext newContextForPersistentStoreCoordinator:[self persistentStoreCoordinator]];
            [context setUndoManager:nil];
            [self startObserveContext:context];
			[threadDictionary setObject:context forKey:kManagedObjectContextKey];
            
            return [threadDictionary objectForKey:kManagedObjectContextKey];
		}
    }
	
	return context;
}

#pragma mark -

- (void)mergeChanges:(NSNotification *)notification {
	//merge changes into the main context on the main thread.
	[self performSelectorOnMainThread:@selector(mergeChangesOnMainThread:)
                           withObject:notification
                        waitUntilDone:NO];  
}

- (void) mergeChangesOnMainThread:(NSNotification*)notification {
	[self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification]; 
}

#pragma mark - Interfaces

- (void)refreshObject:(NSManagedObject *)managedObject  {
    @try {
        if ([self managedObjectContext])   {
            if(managedObject != nil)
                [[self managedObjectContext] refreshObject:managedObject mergeChanges:NO];
        }
    }
    @catch (NSException *exception) {
        //NSLog(@"Exception on refreshObject : %@",[exception description]);
    }
    @finally {
        
    }
}

- (void)resetContext    {
    @try {
        if ([self managedObjectContext]) {
            [[self managedObjectContext] reset];
        }
    }
    @catch (NSException *exception) {
         //NSLog(@"Exception on resetContext : %@",[exception description]);
    }
    @finally {
        
    }
}

// Entity description for given name.
-(id)entityForName:(NSString *)entityName {
    return [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
}

// Create a new entity for given name.
-(id)newEntityForName:(NSString *)entityName {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:[self managedObjectContext]];
}

// To Delete a managed object.
- (void)deleteObject:(NSManagedObject *)object  {
    [[self managedObjectContext] deleteObject:object];
}

// Save entity.
- (BOOL)saveEntity  {
    BOOL success =   NO;
    @try    {
        
        NSError *error;
        if ([[self managedObjectContext] hasChanges]) {
            success = [[self managedObjectContext] save:&error];
            
            if (!success) {
               // NSLog(@"Error While Saving Entity : %@",[error description]);
                error = nil;
            }
          else    {
                //NSLog(@"Entities Saved Successfully....");
            }
        }
        
        return success;
    }
    @catch (NSException *exception) {
       // NSLog(@"Exception on saveEntity : %@",[exception description]);
    }
    @finally {
        return success;
    }
}

#pragma mark - GetAll Documents

- (NSArray *)getAllDocuments:(NSString *)entity {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entity];
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        //
    }
    return result;
}

-(NSArray *)getAllDocuments:(NSString *)entity withOrder:(NSString *)orderKey whetherAscending:(BOOL)whetherAscending{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entity];
    NSError *error = nil;
    
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:orderKey ascending:whetherAscending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByName, nil];
    [request setSortDescriptors:sortDescriptors];
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        //
    }
    return result;
}

- (NSArray *)getAllDocumentsFor:(NSString *)entity withPredicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entity];
    NSError *error = nil;
    if(predicate) {
        request.predicate = predicate;
    }
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        //
    }
    return result;
}

- (NSArray *)getAllDocuments:(NSString *)entity sortByKey:(NSString *)key withPredicate:(NSPredicate *)predicate whetherAscendingOrder:(BOOL) whetherAscending {
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:key ascending:whetherAscending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByName, nil];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entity];
    [request setSortDescriptors:sortDescriptors];
    if(predicate) {
        request.predicate = predicate;
    }
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Coredata getall data by sort BY  %@",error);
    }
    return result;
}
#pragma Mark - Delete all Entries

- (void)deleteAllEntities:(NSString *)nameEntity {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [self.managedObjectContext deleteObject:object];
    }
    
    error = nil;
    [self.managedObjectContext save:&error];
}


@end
