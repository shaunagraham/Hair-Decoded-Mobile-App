//
//  WebServiceWrapper.h
//  ZipPay
//
//  Created by Developer on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"

@class UIPopupWaiting;

@protocol WebServiceWrapperDelegate;

@interface WebServiceWrapper : NSObject
{
    UIPopupWaiting *pleaseWaitDlg;
}


+ (WebServiceWrapper *) sharedWebServiceWrapper;

- (BOOL) OnStartRequest;
- (void) OnEndRequest;
-(NSString*) DeviceType;


@end


