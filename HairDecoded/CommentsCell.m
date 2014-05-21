//
//  CommentsCell.m
//  HairDecoded
//
//  Created by George on 07/02/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "CommentsCell.h"
#import "Custom.h"

@implementation CommentsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.userImage = [[CSAsyncImageView alloc]initWithFrame:CGRectMake(5, 0, 35, 37)];
        [self addSubview:self.userImage];
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(5, 0, 35, 37);
        [self addSubview:self.btn];
        
        self.bubbleView = [[UIView alloc]initWithFrame:CGRectMake(54, 0, 260, 50)];
        [self.bubbleView.layer setMasksToBounds:YES];
        [self.bubbleView.layer setBorderWidth:0.9];
        [self.bubbleView.layer setCornerRadius:3.0];
        [self.bubbleView.layer setBorderColor:[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:0.6].CGColor];

        self.bubbleView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bubbleView];
        
        self.bubble = [[UIImageView alloc]initWithFrame:CGRectMake(45, 3, 22, 22)];
        self.bubble.image = [UIImage imageNamed:@"bubble.png"];
        [self addSubview:self.bubble];
        
        self.username = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 150, 20)];
        self.username.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        self.username.textColor = [UIColor lightGrayColor];
        [self addSubview:self.username];
        
        self.commentDate = [[UILabel alloc]initWithFrame:CGRectMake(210, 0, 100, 20)];
        self.commentDate.font = [UIFont fontWithName:@"HelveticaNeue" size:9.0];
        self.commentDate.textAlignment = NSTextAlignmentRight;
        self.commentDate.textColor = [UIColor lightGrayColor];
        [self addSubview:self.commentDate];
        
        self.content = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, 250, 20)];
        self.content.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
        self.content.numberOfLines = 0;
        self.content.lineBreakMode = NSLineBreakByWordWrapping;
        self.content.textColor = [UIColor grayColor];
        [self addSubview:self.content];
        
        
        
        
//        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(54, 40, 260, 1)];
//        self.lineView.backgroundColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:0.6];
//        [self addSubview:self.lineView];
//        
//        self.heart = [[UIImageView alloc]initWithFrame:CGRectMake(54, 0, 0, 0)];
//        self.heart.image = [UIImage imageNamed:@"like.png"];
//        [self addSubview:self.heart];
//        
//        self.likes = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 250, 20)];
//        self.likes.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:10.0];
//        self.likes.textColor = [UIColor lightGrayColor];
//        [self addSubview:self.likes];
//        
//        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self addSubview:self.likeButton];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
