//
//  SettingsViewController.h
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    
    WebServiceWrapper *pService;
}
@property (weak, nonatomic) IBOutlet UITableView *tabel;
@property (strong, nonatomic) UISwitch *keepPrivate;
@property (strong, nonatomic) UISwitch *savePhotos;


@end
