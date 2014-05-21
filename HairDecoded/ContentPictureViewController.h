//
//  ContentPictureViewController.h
//  HairDecoded
//
//  Created by George on 27/02/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Custom.h"


@interface ContentPictureViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    WebServiceWrapper *pService;
    BOOL pageControlUsed;
    
}
@property (weak, nonatomic) IBOutlet UIButton *likeImage;

@property (weak, nonatomic) IBOutlet UIButton *noComments;

@property (weak, nonatomic) IBOutlet UIImageView *likedImage;

@property (weak, nonatomic) IBOutlet UIButton *left;
@property (weak, nonatomic) IBOutlet UIButton *right;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UIButton *description;

@property (weak, nonatomic) IBOutlet UIButton *calendarUserButton;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic, retain) NSMutableArray* viewsArray;
@property (retain, nonatomic) UIScrollView *sView;
@property (assign, nonatomic) int currentSelection;
@property (nonatomic, retain) NSDate *currentDay;

@property (retain, nonatomic) UIPageControl *pageControl;
-(void)loadScrollViewWithPage:(int)page;
-(int)numberOfPages;
@property (weak, nonatomic) IBOutlet UILabel *likes;


@property (nonatomic, retain) NSMutableArray *content;
@property (nonatomic, retain) NSString *selectionImageID;
@property (strong, nonatomic) IBOutlet UIView *postComment;
@property (weak, nonatomic) IBOutlet UITextView *textComment;
@property (strong, nonatomic) NSString *commentText;
@property (weak, nonatomic) IBOutlet UIButton *post;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *comment;


@property (nonatomic, retain) NSMutableArray *commentsContent;


@end
