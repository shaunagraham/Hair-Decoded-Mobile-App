//
//  UIPopupWaiting.mm
//  Wedding
//
//  Created by Silviu Caragea on 9/28/10.
//  Copyright 2010 Cratima. All rights reserved.
//

#import "UIPopupWaiting.h"


@implementation UIPopupWaiting


@synthesize activityView;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 60, 30, 30)];
		[self addSubview:activityView];
		activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		[activityView startAnimating];
    }
	
    return self;
}

- (void) close
{
	[self dismissWithClickedButtonIndex:0 animated:YES];
}





@end
