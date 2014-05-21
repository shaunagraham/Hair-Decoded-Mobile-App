//
//  DeleteAccountViewController.h
//  HairDecoded
//
//  Created by George on 28/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeleteAccountViewController : UIViewController <UIAlertViewDelegate>
{
     WebServiceWrapper *pService;
}
@property (strong, nonatomic) NSString *content;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UIButton *buttonAction;
@end
