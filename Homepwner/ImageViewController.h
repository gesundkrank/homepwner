//
//  ImageViewController.h
//  Homepwner
//
//  Created by Jan Graßegger on 23.06.13.
//  Copyright (c) 2013 Jan Graßegger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
{
    __weak IBOutlet UIScrollView *scrollView;
    
    __weak IBOutlet UIImageView *imageView;
}
@property (nonatomic, strong) UIImage *image;

@end
