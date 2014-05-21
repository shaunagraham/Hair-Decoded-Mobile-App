//
//  PictureCommentsCell.h
//  HairDecoded
//
//  Created by George on 03/03/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSAsyncImageView.h"

@interface PictureCommentsCell : UITableViewCell

@property (nonatomic, retain) CSAsyncImageView *userImage;

@property (nonatomic, retain) UILabel *username;
@property (nonatomic, retain) UILabel *content;
@property (nonatomic, retain) UILabel *time;



@end
