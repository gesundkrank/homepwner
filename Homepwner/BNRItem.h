//
//  BNRItem.h
//  Homepwner
//
//  Created by Jan Graßegger on 27.06.13.
//  Copyright (c) 2013 Jan Graßegger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BNRItem : NSManagedObject

@property (nonatomic) NSTimeInterval dateCreated;
@property (nonatomic, retain) NSString * imageKey;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic) double orderingValue;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, retain) NSData * thumbnailData;
@property (nonatomic) int32_t valueInDollars;
@property (nonatomic, retain) NSManagedObject *assetType;

- (void)setThumbnailDataFromImage:(UIImage *)image;

@end
