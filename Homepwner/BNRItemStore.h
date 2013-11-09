//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Jan Graßegger on 09.04.13.
//  Copyright (c) 2013 Jan Graßegger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *_allItems;
    NSMutableArray *_allAssetTypes;
    NSManagedObjectContext *_context;
    NSManagedObjectModel *_model;
}

+(BNRItemStore *) sharedStore;

- (NSArray *) allItems;
- (BNRItem *) createItem;
- (void) removeItem:(BNRItem *) p;
- (void) moveItemAtIndex: (int) from toIndex: (int) to;
- (NSString *) itemsArchivePath;
- (BOOL) saveChanges;
- (void) loadAllItems;
- (NSArray *) allAssetTypes;

@end
