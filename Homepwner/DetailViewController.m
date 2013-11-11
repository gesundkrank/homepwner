//
//  DetailViewController.m
//  Homepwner
//
//  Created by Jan Graßegger on 12.04.13.
//  Copyright (c) 2013 Jan Graßegger. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import "AssetTypePicker.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem:" userInfo:nil];
    
    return nil;
}

- (id)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    
    if(self){
        if(isNew){
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UIColor *clr = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        clr = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    } else {
        clr = [UIColor groupTableViewBackgroundColor];
    }
    
    [[self view] setBackgroundColor:clr];
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
    
    //COnvert time interval to NSDate
    NSDate *date =[NSDate dateWithTimeIntervalSinceReferenceDate:[_item dateCreated]];
    [dateLabel setText:[dateFormatter stringFromDate:date]];
    
    NSString *imageKey = [_item imageKey];
    
    if(imageKey){
        //Get image for image key
        UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
        [imageView setImage:imageToDisplay];
    }
    else{
        [imageView setImage:nil];
    }
    
    NSString *typeLabel = [[_item assetType] valueForKey:@"label"];
    if(!typeLabel) typeLabel = @"None";
    
    [assetTypeButton setTitle:[NSString stringWithFormat:@"Type %@", typeLabel] forState:UIControlStateNormal];
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
    if([imagePickerPopover isPopoverVisible]){
        //If popover is already up, get rid of it
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
        return;
    }
    
    
    UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
    [imagePicker setEditing:YES];
                              
    //check if device owns a camera
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    else
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [imagePicker setDelegate:self];
    
    
    // Place image picker on the screen
    // Check for iPad device before instantiating the popover controller
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        // Create new popover controller
        imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [imagePickerPopover setDelegate:self];
        
        //Display the popover controller
        [imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
    
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [_item imageKey];
    
    if(oldKey){
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_item setThumbnailDataFromImage:image];
    
    //Create a CFUUID object - it knows how to create unique id
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    NSString *key = (__bridge NSString *) newUniqueIDString;
    [_item setImageKey:key];
    
    [[BNRImageStore sharedStore] setImage:image forKey:[_item imageKey]];
    
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    [imageView setImage:image];
    
    //Take imagepicker of the screen
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    NSLog(@"User dismissed popover");
    imagePickerPopover = nil;
}

- (void)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:_dismissBlock];
}

- (void)cancel:(id)sender
{
    //If the user cancelled, then remove the BNRItem from store
    [[BNRItemStore sharedStore] removeItem:_item];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:_dismissBlock];
}

- (void)showAssetTypePicker:(id)sender
{
    [[self view] endEditing:YES];
    
    AssetTypePicker *assetTypePicker = [[AssetTypePicker alloc] init];
    [assetTypePicker setItem:_item];
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        // Create new popover controller
        UIPopoverController *assetTypePickerPopover = [[UIPopoverController alloc] initWithContentViewController:assetTypePicker];
        [assetTypePicker setAssetTypePopoverController: assetTypePickerPopover];
        [assetTypePickerPopover setDelegate:assetTypePicker];
        [assetTypePicker setDismissBlock:^{
            NSString *typeLabel = [[_item assetType] valueForKey:@"label"];
           [assetTypeButton setTitle:[NSString stringWithFormat:@"Type %@", typeLabel] forState:UIControlStateNormal];
            }];
        
        //Display the popover controller
        UIButton *button = (UIButton*)sender;
        [assetTypePickerPopover presentPopoverFromRect:[button frame] inView:[self view]permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        [[self navigationController] pushViewController:assetTypePicker animated:YES];
    }
}
@end
