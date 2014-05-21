//
//  Cell.m
//  BarMates
//
//  Created by George Burduhos on 10/18/13.
//
//

#import "Cell.h"
#import "Custom.h"

@implementation Cell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        self.photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.photo.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.photo.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.photo];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
