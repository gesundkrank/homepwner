//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Jan Graßegger on 09.04.13.
//  Copyright (c) 2013 Jan Graßegger. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation BNRItemStore

- (id) init
{
    self = [super init];
    if(self){
        NSString *path = [self itemsArchivePath];
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if(!allItems)
            allItems = [[NSMutableArray alloc] init];
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
    return allItems;
}

- (BNRItem *)createItem
{
    BNRItem *p = [[BNRItem alloc] init];
    [allItems addObject:p];
    
    return p;
}

- (void)removeItem:(BNRItem *)p
{
    [allItems removeObjectIdenticalTo:p];
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
    if(from == to) return;
    
    BNRItem *p = [allItems objectAtIndex:from];
    [allItems removeObjectAtIndex:from];
    
    [allItems insertObject:p atIndex:to];
}

- (NSString *)itemsArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges
{
    //returns success or failure
    NSString *path = [self itemsArchivePath];
    return [NSKeyedArchiver archiveRootObject:allItems toFile:path];
}

@end
