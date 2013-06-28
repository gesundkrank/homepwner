//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Jan Graßegger on 09.04.13.
//  Copyright (c) 2013 Jan Graßegger. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@implementation BNRItemStore

- (id) init
{
    self = [super init];
    if(self){
        //Read in Homepwner.xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        //Where does the SQLite file go?
        NSString *path = [self itemsArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        //Create the managed object context
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:psc];
        
        //The maged objecet context can manage undo, but we don't need it
        [_context setUndoManager:nil];
        [self loadAllItems];
    }
    return self;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+(BNRItemStore *) sharedStore
{
    static BNRItemStore *sharedStore = nil;
    if(!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return sharedStore;
}

- (NSArray * ) allItems
{
    return _allItems;
}

- (BNRItem *)createItem
{
    double order;
    if([_allItems count] == 0)
        order = 1.0;
    else
        order = [[_allItems lastObject] orderingValue] + 1.0;
    
    NSLog(@"Adding after %d items, order = %.2f", [_allItems count], order);
    
    BNRItem *p = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" inManagedObjectContext:_context];
    [p setOrderingValue:order];
    
    [_allItems addObject:p];
    
    return p;
}

- (void)removeItem:(BNRItem *)p
{
    NSString *key = [p imageKey];
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    [_context delete:p];
    [_allItems removeObjectIdenticalTo:p];
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
    if(from == to) return;
    
    BNRItem *p = [_allItems objectAtIndex:from];
    [_allItems removeObjectAtIndex:from];
    
    [_allItems insertObject:p atIndex:to];
    
    //Computing a new orderValue
    double lowerBound = 0.0;
    
    // Is there an object before it in the array?
    if(to > 0) lowerBound = [[_allItems objectAtIndex:to - 1] orderingValue];
    else lowerBound = [[_allItems objectAtIndex:1] orderingValue] - 2.0;
    
    double upperBound = 0.0;
    
    // Is there an object after it in the array?
    if( to < [_allItems count] - 1) upperBound = [[_allItems objectAtIndex:to + 1] orderingValue];
    else upperBound = [[_allItems objectAtIndex: to -1] orderingValue] + 2.0;
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    [p setOrderingValue:newOrderValue];
}

- (NSString *)itemsArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges
{
    NSError *error = nil;
    BOOL successful = [_context save:&error];
    if(!successful){
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    
    return successful;
}

- (void)loadAllItems
{
    if(!_allItems){
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [[_model entitiesByName] objectForKey:@"BNRItem"];
        [request setEntity:e];
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSError *err;
        NSArray *result = [_context executeFetchRequest:request error:&err];
        if(!result){
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [err localizedDescription]];
        }
        
        _allItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

@end
