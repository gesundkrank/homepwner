//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Jan Graßegger on 09.04.13.
//  Copyright (c) 2013 Jan Graßegger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"

@interface ItemsViewController : UITableViewController<UIPopoverControllerDelegate>
{
    UIPopoverController *imagePopover;
}
- (IBAction)addNewItem:(id)sender;

@end
