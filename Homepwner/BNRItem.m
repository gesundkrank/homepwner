//
//  BNRItem.m
//  Homepwner
//
//  Created by Jan Graßegger on 09.04.13.
//  Copyright (c) 2013 Jan Graßegger. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem


- (id) init
{
    return [self initWithItemName:@"Item" valueInDollars:0 serialNumber:@""];
}

- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    self = [super init];
    if(self){
        [self setItemName:name];
        [self setSerialNumber:sNumber];
        [self setValueInDollars:value];
        _dateCreated = [[NSDate alloc] init];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        [self setItemName:[aDecoder decodeObjectForKey:@"itemName"]];
        [self setSerialNumber:[aDecoder decodeObjectForKey:@"serialNumber"]];
        [self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
        
        [self setValueInDollars:[aDecoder decodeIntForKey:@"valueInDollars"]];
        
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        
        _thumbnailData = [aDecoder decodeObjectForKey:@"thumbnailData"];
    }
    
    return self;
}

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
                                   _itemName,
                                   _serialNumber,
                                   _valueInDollars,
                                   _dateCreated];
    return descriptionString;
}

- (UIImage *)thumbnail
{
    //If there is no thumbnailData it cannot be returned
    if(!_thumbnailData){
        return nil;
    }
    
    // If I have not yet created my thumbnail image from my data, do so now
    if(!_thumbnail){
        //Create image from data
        _thumbnail = [UIImage imageWithData:_thumbnailData];
    }
    
    return _thumbnail;
}

- (void)setThumbnailDataFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    
    //The rectangle of the thumbnail
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    //Figure out scaling ratio
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
    
    //Create transparent bitmap context with a scaling factor
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    //Create a path that is a rounded reactangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    //Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    //Center image in thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) /2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    // Draw the image on it
    [image drawInRect:projectRect];
    
    //Get the image from image context, keep it as your thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:smallImage];
    
    //Get the PNG represantation of the image and set it as our archivable data
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailData:data];
    
    UIGraphicsEndImageContext();
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_itemName forKey:@"itemName"];
    [aCoder encodeObject:_serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:_dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:_imageKey forKey:@"imageKey"];
    [aCoder encodeObject:_thumbnailData forKey:@"thumbnailData"];
    
    [aCoder encodeInt:_valueInDollars forKey:@"valueInDollars"];
   
}

+ (id)randomItem
{
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Flffy", @"Rusty", @"Shiny", nil];
    NSArray *randomNounList = [NSArray arrayWithObjects:@"Bear", @"Spork", @"Mac", nil];
    
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];
    int randomValue = rand() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 26,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];
    BNRItem *newItem = [[self alloc] initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
    return newItem;
}

@end
