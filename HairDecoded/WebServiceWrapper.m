//
//  WebServiceWrapper.m
//  ZipPay
//
//  Created by Developer on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebServiceWrapper.h"
#import "UIPopupWaiting.h"
//#import "Custom.h"

@implementation WebServiceWrapper

SYNTHESIZE_SINGLETON_FOR_CLASS(WebServiceWrapper);

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        pleaseWaitDlg = [[UIPopupWaiting alloc] initWithTitle:@"" message:@"Please wait..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];		

        
        
    }
    
    return self;
}

-(NSString*) DeviceType
{	
#if TARGET_IPHONE_SIMULATOR
	NSString *deviceID= @"Simulator";
#else		
	NSString *deviceID=	[[UIDevice currentDevice] model];	
#endif
	
	return deviceID;
}

- (BOOL) OnStartRequest
{
	if(!pleaseWaitDlg.visible)
		[pleaseWaitDlg show];	
	
	return TRUE;
}

- (void) OnEndRequest
{
	if(pleaseWaitDlg.visible)
		[pleaseWaitDlg close];
}







@end
