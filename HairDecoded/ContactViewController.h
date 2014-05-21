//
//  ContactViewController.h
//  HairDecoded
//
//  Created by George on 01/04/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
     WebServiceWrapper *pService;
}

@property (weak, nonatomic) IBOutlet UILabel *textHolder;
@property (nonatomic, strong) NSString *messageText;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextView *message;
@property (weak, nonatomic) IBOutlet UIButton *send;

@end
