//
//  CommentsViewController.h
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Custom.h"

@interface CommentsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    WebServiceWrapper *pService;
}
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (nonatomic, retain) NSMutableArray *content;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) IBOutlet UIView *postComment;

@property (strong, nonatomic) NSString *comment_id;
@property (weak, nonatomic) IBOutlet UITextView *textComment;
@property (strong, nonatomic) NSString *commentText;
@property (weak, nonatomic) IBOutlet UIButton *post;
@property (weak, nonatomic) IBOutlet UIButton *cancel;


@end
