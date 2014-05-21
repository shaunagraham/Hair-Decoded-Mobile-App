//
//  FollowersViewController.h
//  HairDecoded
//
//  Created by George on 25/04/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FollowersViewController : UIViewController
{
    WebServiceWrapper *pService;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *content;
@property (nonatomic, retain) NSMutableArray *followers;
@property (nonatomic, retain) NSMutableArray *following;

@property (nonatomic, strong) NSString *followerID;
@property (nonatomic, strong) NSString *calendarID;
@property (nonatomic, strong) UISegmentedControl *statFilter;
@property (weak, nonatomic) IBOutlet UILabel *nothing;

@end
