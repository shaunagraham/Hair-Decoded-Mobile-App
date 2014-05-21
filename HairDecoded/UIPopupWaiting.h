//
//  UIPopupWaiting.h
//  Wedding
//
//  Created by Silviu Caragea on 9/28/10.
//  Copyright 2010 Cratima. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIPopupWaiting : UIAlertView
{
	UIActivityIndicatorView *activityView;
}

@property (nonatomic, retain) UIActivityIndicatorView *activityView;

- (void) close;

@end
