//
//  AssetTypePicker.h
//  Homepwner
//
//  Created by Jan Grassegger on 09.11.13.
//  Copyright (c) 2013 Jan Graßegger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface AssetTypePicker : UITableViewController<UIPopoverControllerDelegate>

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, strong) UIPopoverController *assetTypePopoverController;


@end
