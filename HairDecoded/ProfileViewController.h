//
//  CreateProfileViewController.h
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropImageViewController.h"
#import "Custom.h"

@interface ProfileViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,CropImageDelegate,UIActionSheetDelegate>
{
    WebServiceWrapper *pService;
    int x;
}

@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@property (nonatomic, retain) NSDictionary *userInfo;
@property (retain, nonatomic) UIImagePickerController *imagePickerController;
@property (retain, nonatomic) UIImage *croppedImage;
@property (weak, nonatomic) IBOutlet UIImageView *genderImage;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (assign, nonatomic) int hairTypeSelected;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *hairType;
@property (weak, nonatomic) IBOutlet UITextView *aboutMe;
@property (assign, nonatomic) int isInitial;
@property (nonatomic, retain) NSString *app_code;
@property (nonatomic, retain) NSString *isPrivate;

@property (retain, nonatomic) NSString *aboutText;


@property (weak, nonatomic) IBOutlet UISwitch *privateSwitch;



@end
