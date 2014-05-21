//
//  HairTypeViewController.h
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HairTypeViewController : UIViewController <UIAlertViewDelegate>
{
    UIAlertView *alert;
}
@property (nonatomic, retain) NSDictionary *userInfo;
@property (nonatomic, retain) NSString *app_code;


@property (weak, nonatomic) IBOutlet UILabel *l1;
@property (weak, nonatomic) IBOutlet UILabel *l2;
@property (weak, nonatomic) IBOutlet UILabel *l3;
@property (weak, nonatomic) IBOutlet UILabel *l4;


@end
