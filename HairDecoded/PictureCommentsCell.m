//
//  PictureCommentsCell.m
//  HairDecoded
//
//  Created by George on 03/03/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "PictureCommentsCell.h"

@implementation PictureCommentsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.userImage = [[CSAsyncImageView alloc]initWithFrame:CGRectMake(10, 3, 35, 37)];
        [self addSubview:self.userImage];
        
        self.username = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 170, 15)];
        self.username.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        self.username.textColor = [UIColor darkGrayColor];
        [self addSubview:self.username];
        
        self.content = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, 260, 20)];
        self.content.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        self.content.numberOfLines = 0;
        self.content.lineBreakMode = NSLineBreakByWordWrapping;
        self.content.textColor = [UIColor grayColor];
        [self addSubview:self.content];
        
        
        self.time = [[UILabel alloc]initWithFrame:CGRectMake(230, 0, 85, 23)];
        self.time.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
        self.time.numberOfLines = 2;
        self.time.textAlignment = NSTextAlignmentRight;
        self.time.textColor = [UIColor grayColor];
        [self addSubview:self.time];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
