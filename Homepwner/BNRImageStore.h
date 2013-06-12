//
//  BNRImageStore.h
//  Homepwner
//
//  Created by Jan Graßegger on 12.06.13.
//  Copyright (c) 2013 Jan Graßegger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}
+ (BNRImageStore*) sharedStore;

-(void) setImage:(UIImage *)i forKey:(NSString*) s;
-(UIImage *) imageForKey:(NSString*)s;
-(void) deleteImageForKey:(NSString *)s;

@end
