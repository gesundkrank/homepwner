//
//  DetailViewController.m
//  Homepwner
//
//  Created by Jan Graßegger on 12.04.13.
//  Copyright (c) 2013 Jan Graßegger. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [nameField setText:[_item itemName]];
    [serialNumberField setText:[_item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d",[_item valueInDollars]]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [dateLabel setText:[dateFormatter stringFromDate:[_item dateCreated]]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[self view] endEditing:YES];
    
    [_item setItemName:[nameField text]];
    [_item setSerialNumber:[serialNumberField text]];
    [_item setValueInDollars:[[valueField text] intValue]];
}

- (void)setItem:(BNRItem *)item
{
    _item = item;
    [[self navigationItem] setTitle:[_item itemName]];
}


- (IBAction)takePicture:(id)sender{
    UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
                              
    //check if device owns a camera
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    else
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [imagePicker setDelegate:self];
    
    // Place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [imageView setImage:image];
    
    //Take imagepicker of the screen
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
