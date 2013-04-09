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
    BNRItem *p = [BNRItem randomItem];
    [allItems addObject:p];
    
    return p;
}

@end
