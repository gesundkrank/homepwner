//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Jan Graßegger on 09.04.13.
//  Copyright (c) 2013 Jan Graßegger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
}

+(BNRItemStore *) sharedStore;

- (NSArray *) allItems;
- (BNRItem *) createItem;
- (void) removeItem:(BNRItem *) p;

@end
