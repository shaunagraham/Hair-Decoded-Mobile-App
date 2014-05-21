//
//  CommentsViewController.m
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentsCell.h"
#import "ContentPictureViewController.h"
#import "CalendarViewController.h"
#import "NSDate+DateTools.h"

@interface CommentsViewController ()

@end

@implementation CommentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pService = [WebServiceWrapper sharedWebServiceWrapper];
    }
    return self;
}

- (IBAction)comment:(id)sender {
    [self.view bringSubviewToFront:self.postComment];
    [self.textComment becomeFirstResponder];
}
- (IBAction)sendPost:(id)sender {
    self.commentText = self.textComment.text;
    
    if ([self.commentText isEqualToString:@""]){
        ShowMessageBox(@"You need to write something", @"", -1, nil);
        return;
    }
    
    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(setCommentRequest:) withObject:nil];
    
}
- (IBAction)cancelPost:(id)sender {
    [self.view sendSubviewToBack:self.postComment];
    [self.textComment resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(getCommentsRequest:) withObject:nil];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(removeBadge:) userInfo:nil repeats:NO];
    self.navigationItem.title = @"Comments";
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"Back";
    
}

-(void)removeBadge:(id)sender{
    UITabBarItem *tabItem = [[[self.tabBarController tabBar] items] objectAtIndex:3];
    [tabItem setBadgeValue:nil];

}

-(void)likeComment:(id)sender{
    ////NSLog(@"working");
    UIButton *btn = (UIButton*)sender;
    self.comment_id = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(likeCommentsRequest:) withObject:nil];
}

#pragma UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.content.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"CellIdentifier";
    
    CommentsCell *cell = (CommentsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil){
        cell = [[CommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.userImage loadImage:[UIImage imageNamed:@"img.png"]];
    int y = 20;
    int h = 0;
    
    NSString *string = [[self.content objectAtIndex:indexPath.row] objectForKey:@"comment"];
    NSLog(@"%@",[self.content objectAtIndex:indexPath.row]);
    
    NSString * cellText = [[self.content objectAtIndex:indexPath.row] objectForKey:@"comment"];
    
    //    if ([[[self.content objectAtIndex:indexPath.row] objectForKey:@"like"] intValue] == 1){
    //        cell.likes.text = [NSString stringWithFormat:@"%@ like",[[self.content objectAtIndex:indexPath.row] objectForKey:@"like"]];
    //    }
    //    else cell.likes.text = [NSString stringWithFormat:@"%@ likes",[[self.content objectAtIndex:indexPath.row] objectForKey:@"like"]];
    

    NSString *dateString = [NSString stringWithFormat:@"%@ %@",[[self.content objectAtIndex:indexPath.row] objectForKey:@"day"],[[self.content objectAtIndex:indexPath.row] objectForKey:@"hour"]];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc]init];
    [formatDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [formatDate dateFromString:dateString];
    
    
    if ([string rangeOfString:@"likes your photo"].location == NSNotFound) {
        
        
        if ([string rangeOfString:@"is following you"].location == NSNotFound){
            //NSLog(@"%d normal",indexPath.row);
            [cell.userImage loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,[[self.content objectAtIndex:indexPath.row] objectForKey:@"img"]]] andName:[[self.content objectAtIndex:indexPath.row] objectForKey:@"img"]];
            cell.username.text = [[self.content objectAtIndex:indexPath.row] objectForKey:@"username"];
            cell.content.textColor = [UIColor grayColor];
            cell.username.textColor = commonColor;
            cell.content.text = cellText;
        }
        else {
             //NSLog(@"%d following",indexPath.row);
            [cell.userImage loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,[[self.content objectAtIndex:indexPath.row] objectForKey:@"profile_img"]]] andName:[[self.content objectAtIndex:indexPath.row] objectForKey:@"profile_img"]];
            cell.username.text = @"";
            cell.commentDate.center = CGPointMake(cell.commentDate.center.x, cell.username.center.y);

            y = 5;
            h = 15;
             cell.content.text = cellText;
            int length = [[[self.content objectAtIndex:indexPath.row] objectForKey:@"username"]length];
            NSMutableAttributedString *textR = [[NSMutableAttributedString alloc] initWithAttributedString: cell.content.attributedText];
            [textR addAttribute:NSForegroundColorAttributeName value:commonColor range: NSMakeRange(0, length)];
            [textR addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range: NSMakeRange(length,[cell.content.text length]-length)];
            [cell.content setAttributedText:textR];

        }
    }
    else {
         //NSLog(@"%d like",indexPath.row);
        [cell.userImage loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,[[self.content objectAtIndex:indexPath.row] objectForKey:@"img"]]] andName:[[self.content objectAtIndex:indexPath.row] objectForKey:@"img"]];
        cell.username.text = @"";
        cell.commentDate.center = CGPointMake(cell.commentDate.center.x, cell.username.center.y);
        y = 5;
        h = 15;
        cell.content.text = cellText;
        int length = [[[self.content objectAtIndex:indexPath.row] objectForKey:@"username"]length];
        NSMutableAttributedString *textR = [[NSMutableAttributedString alloc] initWithAttributedString: cell.content.attributedText];
        [textR addAttribute:NSForegroundColorAttributeName value:commonColor range: NSMakeRange(0, length)];
        [textR addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range: NSMakeRange(length,[cell.content.text length]-length)];
        [cell.content setAttributedText:textR];
    }
    
    cell.commentDate.text = [currentDate timeAgoSinceNow];
    
    UIFont *cellFont = [UIFont fontWithName:@"HelveticaNeue" size:13];
    CGSize constraintSize = CGSizeMake(250.0f, MAXFLOAT);
    
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    cell.content.frame = CGRectMake(60, y, 250, labelSize.height);
    
    cell.bubbleView.frame = CGRectMake(54, 0, 260, labelSize.height+30-h);
    
    
    cell.btn.tag = (int)indexPath.row;
    
        [cell.btn addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    
    

    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * cellText = [[self.content objectAtIndex:indexPath.row] objectForKey:@"comment"];
    
    UIFont *cellFont = [UIFont fontWithName:@"HelveticaNeue" size:13];
    CGSize constraintSize = CGSizeMake(250.0f, MAXFLOAT);
    
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    
    if ([cellText rangeOfString:@"likes your photo"].location == NSNotFound) {
        
        
        if ([cellText rangeOfString:@"is following you"].location == NSNotFound){
        }
        else {
            return 44;
        }
    }
    else {
        return 44;
    }

    
    
    
    
    if (labelSize.height < 14) return 50;
    return labelSize.height + 30+10;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"blbllb");
//    NSString *string = [[self.content objectAtIndex:indexPath.row] objectForKey:@"comment"];
//    
//    if ([string rangeOfString:@"likes your photo"].location == NSNotFound) {
//    }
//    else {
        NSDictionary *dict = [self.content objectAtIndex:indexPath.row];
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        delegate.user_id = [dict objectForKey:@"id"];
            CalendarViewController *calendar = [[CalendarViewController alloc]init];
            calendar.comesFromFollwers = 1;
            [self.navigationController pushViewController:calendar animated:YES];
        

}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    v.backgroundColor = [UIColor whiteColor];
    return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(void)selectImage:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self.content objectAtIndex:btn.tag]];
    NSLog(@"%@",dict);
    
    
    if ([[dict objectForKey:@"comment"] rangeOfString:@"is following you"].location == NSNotFound){
        [dict setValue:ownID() forKey:@"id"];
        [dict setValue:username() forKey:@"username"];
        [dict setValue:profile_img() forKey:@"profile_img"];
        
        ContentPictureViewController *content = [[ContentPictureViewController alloc]init];
        content.currentSelection = 0;
        content.content = [NSMutableArray arrayWithObject:dict];
        [self.navigationController pushViewController:content animated:YES];
    }
    else {
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        delegate.user_id = [dict objectForKey:@"id"];
        CalendarViewController *calendar = [[CalendarViewController alloc]init];
        calendar.comesFromFollwers = 1;
        [self.navigationController pushViewController:calendar animated:YES];
    }

    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textComment.contentInset = UIEdgeInsetsMake(2.0,1.0,0,0.0); // set value as per your requirement.
    
    
    [self.comment.layer setMasksToBounds:YES];
	[self.comment.layer setCornerRadius:5.0];
    self.comment.backgroundColor = commonColor;
    
    [self.cancel.layer setMasksToBounds:YES];
	[self.cancel.layer setCornerRadius:5.0];
    self.cancel.backgroundColor = commonColor;
    
    [self.post.layer setMasksToBounds:YES];
	[self.post.layer setCornerRadius:5.0];
    self.post.backgroundColor = commonColor;
    
    [self.textComment.layer setMasksToBounds:YES];
	[self.textComment.layer setCornerRadius:5.0];
    [self.textComment.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.textComment.layer setBorderWidth:2.0];
    
    self.postComment.frame = CGRectMake(0, 64, 320, 280);
    [self.view addSubview:self.postComment];
    [self.view sendSubviewToBack:self.postComment];
    
}

#pragma Like Comment

-(void)likeCommentsRequest:(id)sender{
    @autoreleasepool {
        NSString *url = [NSString stringWithFormat:@"%@&token=%@&comment_id=%@",LikeComment,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],self.comment_id];
        
        ////NSLog(@"%@",url);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        ////NSLog(@"%@",returnString);
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            
            self.content = [[NSMutableArray alloc]initWithArray:(NSArray*)[[dict objectForKey:@"response"] objectForKey:@"profile"]];
            [self performSelectorOnMainThread:@selector(likeCommentsSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(likeCommentsError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
}

-(void)likeCommentsSuccess:(id)sender{
    [self performSelectorInBackground:@selector(getCommentsRequest:) withObject:nil];
    
}

-(void)likeCommentsError:(id)sender{
    ShowMessageBox(@"You already like this comment", @"", -1, nil);
    
    [pService OnEndRequest];
}


#pragma Get Comments

-(void)getCommentsRequest:(id)sender{
    @autoreleasepool {
        NSString *url = [NSString stringWithFormat:@"%@&token=%@&id=%@",GetComments,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],ownID()];
        
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        ////NSLog(@"%@",returnString);
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            
            self.content = [[NSMutableArray alloc]initWithArray:(NSArray*)[[dict objectForKey:@"response"] objectForKey:@"profile"]];
            //NSLog(@"%@",self.content);
            [self performSelectorOnMainThread:@selector(getCommentsSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(getCommentsError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
}

-(void)getCommentsSuccess:(id)sender{
    [self.table reloadData];
    [pService OnEndRequest];
}

-(void)getCommentsError:(id)sender{
    [pService OnEndRequest];
}

#pragma Set Comment

-(void)setCommentRequest:(id)sender{
    @autoreleasepool {
        NSString *url = [NSString stringWithFormat:@"%@",SetComment];
        
        //[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"]
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        
        
        NSString *mpfBoundry = @"-----------------------------7d91191f100ca";
        [request setValue:[NSString stringWithFormat:@"multipart/form-data, boundary=%@",mpfBoundry] forHTTPHeaderField:@"Content-Type"];
        NSMutableData *postbody = [NSMutableData data];
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"comment\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:self.commentText] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [request setHTTPBody:postbody];
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        ////NSLog(@"%@",returnString);
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            
            
            [self performSelectorOnMainThread:@selector(setCommentsSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(setCommentsError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
}

-(void)setCommentsSuccess:(id)sender{
    
    [self.view sendSubviewToBack:self.postComment];
    [self.textComment resignFirstResponder];
    
    [self performSelectorInBackground:@selector(getCommentsRequest:) withObject:nil];
}

-(void)setCommentsError:(id)sender{
    [pService OnEndRequest];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
