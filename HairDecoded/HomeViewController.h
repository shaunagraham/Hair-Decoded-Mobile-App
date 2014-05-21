//
//  HomeViewController.h
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Custom.h"

@interface HomeViewController : UIViewController <UITextFieldDelegate>
{
    WebServiceWrapper *pService;
    UIAlertView *alert;
    NSDate *selectedDate;
    NSDateFormatter *formatDate;
}

@property (weak, nonatomic) IBOutlet UILabel *noFollow;
@property (nonatomic, retain) UIView *viewHidden;

@property (weak, nonatomic) IBOutlet UILabel *nothingFound;
@property (weak, nonatomic) IBOutlet UILabel *likePhotosLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *sView1;
@property (weak, nonatomic) IBOutlet UIScrollView *sView2;
@property (weak, nonatomic) IBOutlet UIScrollView *sView3;
@property (weak, nonatomic) IBOutlet UIScrollView *sView4;

@property (nonatomic, retain) NSMutableArray *content;
@property (nonatomic, retain) NSMutableArray *allContent;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hairSegment;

@property (weak, nonatomic) IBOutlet UITextField *search;


@end
