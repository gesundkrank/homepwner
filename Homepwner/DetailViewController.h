//
//  DetailViewController.h
//  Homepwner
//
//  Created by Jan Graßegger on 12.04.13.
//  Copyright (c) 2013 Jan Graßegger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
}
@property (nonatomic, strong) BNRItem *item;

@end