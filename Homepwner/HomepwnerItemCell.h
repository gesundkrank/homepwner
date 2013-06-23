//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by Jan Graßegger on 22.06.13.
//  Copyright (c) 2013 Jan Graßegger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomepwnerItemCell : UITableViewCell

@property (weak, nonatomic) id controller;
@property (weak, nonatomic) UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

- (IBAction)showImage:(id)sender;

@end
