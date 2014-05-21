//
//  CommentsCell.h
//  HairDecoded
//
//  Created by George on 07/02/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSAsyncImageView.h"

@interface CommentsCell : UITableViewCell

@property (nonatomic, retain) CSAsyncImageView *userImage;
@property (nonatomic, retain) UIButton *btn;
@property (nonatomic, retain) UIImageView *bubble;
@property (nonatomic, retain) UIView *bubbleView;
@property (nonatomic, retain) UIView *lineView;

@property (nonatomic, retain) UIImageView *heart;
@property (nonatomic, retain) UILabel *likes;
@property (nonatomic, retain) UIButton *likeButton;

@property (nonatomic, retain) UILabel *username;
@property (nonatomic, retain) UILabel *content;
@property (nonatomic, retain) UILabel *commentDate;



@end
