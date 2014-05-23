//
//  BNRDetaiViewController.m
//  Homepwner
//
//  Created by WaterWood on 14-5-14.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "BNRDetaiViewController.h"
#import "BNRDateViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNROverlayView.h"
#import "BNRItemStore.h"

@interface BNRDetaiViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *serialNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;

@end

@implementation BNRDetaiViewController

- (instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                      target:self
                                                                                      action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(updateFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong Initializer" reason:@"User initForNewItem" userInfo:nil];
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BNRItem *item = self.item;
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    NSString *imageKey = self.item.imageKey;
    UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
    self.imageView.image = imageToDisplay;
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    //"save" changes to item
    BNRItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
    
    [self updateFonts];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView = iv;
    [self.view addSubview:iv];
    
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
    
    NSDictionary *nameMap = @{@"imageView": self.imageView,
                              @"toolbar": self.toolbar,
                              @"dateLabel": self.dateLabel};
    
    NSArray *horizontalContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:nameMap];
    
    NSArray *verticalContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:nameMap];
    
    [self.view addConstraints:horizontalContraints];
    [self.view addConstraints:verticalContraints];
}

- (void)updateFonts
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font = font;
    self.serialNumberField.font = font;
    self.valueLabel.font = font;
    self.dateLabel.font = font;
    
    self.nameField.font = font;
    self.serialNumberField.font = font;
    self.valueField.font = font;
}

- (void)prepareViewsForOrientation: (UIInterfaceOrientation)orientation
{
    // Is it a iPad
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // Is it landscape
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

- (void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (IBAction)clickOk:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickChangeDate:(id)sender
{
    BNRDateViewController *dateController = [[BNRDateViewController alloc] init];
    dateController.item = self.item;
    [self.navigationController pushViewController:dateController animated:YES];
}


- (IBAction)takePicture:(id)sender
{
    // looks like in iOS7.1, we don't need these codes to protect crashing from double tapping camera button
    if ([self.imagePickerPopover isPopoverVisible]) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    UIView *overlayView = [[BNROverlayView alloc] initWithFrame:imagePicker.view.frame];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraOverlayView = overlayView;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    //[self presentViewController:imagePicker animated:YES completion:nil];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        //!!!: 需要为popoverViewController 添加背景
        //UIImage *image = [UIImage imageNamed:@"background"];
        
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender
                                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                                        animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self.item setThumbnailFromImage:image];
    
    [[BNRImageStore sharedStore] setImage:image forKey:self.item.imageKey];
    
    self.imageView.image = image;
    
    // do i have a popover
    if (self.imagePickerPopover) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)clearImage:(id)sender
{
    self.imageView.image = nil;
    NSString *imageKey = self.item.imageKey;
    [[BNRImageStore sharedStore] deleteImageForKey:imageKey];
}


- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    [[BNRItemStore sharedStore] removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

@end













