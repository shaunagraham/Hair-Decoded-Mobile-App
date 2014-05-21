//
//  PhotoViewController.h
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropImageViewController.h"
#import "Custom.h"
#import "AFPhotoEditorController.h"
#import "NSString+Emojize.h"


@interface PhotoViewController : UIViewController <UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate,CropImageDelegate,UIActionSheetDelegate,AFPhotoEditorControllerDelegate>
{
    WebServiceWrapper *pService;
}


@property (weak, nonatomic) IBOutlet UIView *contentPhoto;
@property (weak, nonatomic) IBOutlet UILabel *addPhotoLabel;

@property (retain, nonatomic) AFPhotoEditorController *editorController;

@property (retain, nonatomic) UIImagePickerController *imagePickerController;
@property (retain, nonatomic) UIImage *croppedImage;
@property (assign, nonatomic) int hairTypeSelected;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) NSString *descriptionText;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;

@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectedHair;
@property (weak, nonatomic) IBOutlet UIButton *UploadButton;


@end
