//
//  AppDelegate.h
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"

#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *saved_user_id;
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *navController;
@property (strong, nonatomic) UITabBarController *tabBarController;


@end
