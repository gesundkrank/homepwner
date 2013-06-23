//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Jan Graßegger on 22.06.13.
//  Copyright (c) 2013 Jan Graßegger. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showImage:(id)sender {
    //GEt name of this method
    NSString *selector = NSStringFromSelector(_cmd);
    //append rest of method name
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    //Prepare selector from string
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    
    if(indexPath){
        if([[self controller] respondsToSelector:newSelector])
            [[self controller] performSelector:newSelector withObject:sender withObject:indexPath];
    }
    
}
@end
