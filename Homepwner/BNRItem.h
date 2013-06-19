//
//  BNRItem.h
//  Homepwner
//
//  Created by Jan Graßegger on 09.04.13.
//  Copyright (c) 2013 Jan Graßegger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject<NSCoding>

@property(nonatomic) BNRItem *containedItem;
@property(nonatomic) BNRItem *container;
@property(nonatomic, copy) NSString *itemName, *serialNumber;
@property(nonatomic) int valueInDollars;
@property(nonatomic, readonly) NSDate *dateCreated;

@property(nonatomic, copy) NSString *imageKey;


-(id) init;
-(id) initWithItemName:(NSString*) name
        valueInDollars:(int) value
          serialNumber:(NSString *) sNumber;

+(id) randomItem;

@end
