//
//  ContentPictureViewController.m
//  HairDecoded
//
//  Created by George on 27/02/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "ContentPictureViewController.h"
#import "CSAsyncImageView.h"
#import "PictureCommentsCell.h"
#import "CalendarViewController.h"
#import "NSDate+DateTools.h"

int oldPageNumber2 = 0;
int kNumberOfPages;

@interface ContentPictureViewController ()

@end

@implementation ContentPictureViewController

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
    self.textComment.text = @"";
    [self.view bringSubviewToFront:self.postComment];
    [self.textComment becomeFirstResponder];
    self.sView.userInteractionEnabled = NO;
}

- (IBAction)cancel:(id)sender {
    [self.view sendSubviewToBack:self.postComment];
    [self.textComment resignFirstResponder];
    self.sView.userInteractionEnabled = YES;

}

- (IBAction)post:(id)sender {
    self.commentText = self.textComment.text;
    
    if ([self.commentText isEqualToString:@""]){
        ShowMessageBox(@"You need to write something", @"", -1, nil);
        return;
    }
    self.sView.userInteractionEnabled = YES;

    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(setCommentRequest:) withObject:nil];
}

- (IBAction)likeImage:(id)sender {
//    [pService OnStartRequest];
//    [self performSelectorInBackground:@selector(likeImageRequest:) withObject:nil];
}

#pragma Get likeImage

-(void)likeImageRequest:(id)sender{
    @autoreleasepool {
        NSString *url = [NSString stringWithFormat:@"%@&token=%@&img_id=%@",LikeImage,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],self.selectionImageID];
        
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",returnString);
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            
            [self performSelectorOnMainThread:@selector(getLikeSuccess:) withObject:[dict objectForKey:@"response"] waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(getLikeImageError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
}

-(void)getLikeSuccess:(id)sender{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[self.content objectAtIndex:self.pageControl.currentPage]];
    
    NSDictionary *response = (NSDictionary*)sender;
    
    if ([[response objectForKey:@"reason"] isEqualToString:@"like+"])
    [dict setValue:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"like"] intValue]+1] forKey:@"like"];
    else [dict setValue:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"like"] intValue]-1] forKey:@"like"];
    [self.content replaceObjectAtIndex:self.pageControl.currentPage withObject:dict];
    if ([[dict objectForKey:@"like"] intValue] == 1)self.likes.text = @"1 people like this";
    else self.likes.text = [NSString stringWithFormat:@"%d people like this",[[dict objectForKey:@"like"] intValue]];
    
    if ([[response objectForKey:@"reason"] isEqualToString:@"like+"])self.likedImage.image = [UIImage imageNamed:@"liked.png"];
    else self.likedImage.image = [UIImage imageNamed:@"like.png"];
    [pService OnEndRequest];
}

-(void)getLikeImageError:(id)sender{
    ShowMessageBox(@"Try again", @"", -1, nil);
    [pService OnEndRequest];
}

- (IBAction)calendarUser:(id)sender {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    delegate.user_id = [[self.content objectAtIndex:self.pageControl.currentPage] objectForKey:@"id"];

        CalendarViewController *calendar = [[CalendarViewController alloc]init];
        calendar.comesFromFollwers = 1;
        [self.navigationController pushViewController:calendar animated:YES];
}


-(void)tapLike:(id)sender{
    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(likeImageRequest:) withObject:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"MMMM d"];
    self.navigationItem.title = [format stringFromDate:self.currentDay];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"Back";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLike:)];
    tap.numberOfTapsRequired = 1;
    [self.likeImage addGestureRecognizer:tap];

    
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"MMMM d"];
    self.navigationItem.title = [format stringFromDate:self.currentDay];
    [[UIBarButtonItem appearance] setTintColor:commonColor];
    
    self.navigationController.navigationBar.tintColor = commonColor;
    self.textComment.contentInset = UIEdgeInsetsMake(2.0,1.0,0,0.0); // set value as per your requirement.
    
//    [self.comment.layer setMasksToBounds:YES];
//	[self.comment.layer setCornerRadius:5.0];
//    self.comment.backgroundColor = commonColor;
    
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
    
    self.postComment.frame = CGRectMake(0, 64, 320, 175);
    [self.view addSubview:self.postComment];
    [self.view sendSubviewToBack:self.postComment];
    
    self.textComment.textContainerInset = UIEdgeInsetsZero;
    
    self.automaticallyAdjustsScrollViewInsets = NO; // Avoid the top UITextView space, iOS7 (~bug?)

    
    [[UIBarButtonItem appearance] setTintColor:commonColor];
    
    
    NSMutableArray *views = [[NSMutableArray alloc] init];
    int pagesNo = (int)[self.content count];
    for (unsigned i = 0; i < [self.content count]; i++) {
        [views addObject:[NSNull null]];
    }
    self.viewsArray = views;
    
    self.sView.pagingEnabled = YES;
    self.sView.showsHorizontalScrollIndicator = NO;
    self.sView.showsVerticalScrollIndicator = NO;
    self.sView.scrollsToTop = NO;
    self.sView.delegate = self;
    self.sView.contentSize = CGSizeMake(self.sView.frame.size.width*pagesNo, 260);
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.numberOfPages = pagesNo;
    self.pageControl.currentPage = self.currentSelection;
    
    
    
    kNumberOfPages = (int)self.content.count;
    [self changePage:self.currentSelection];
    [self loadDetails:[self.content objectAtIndex:self.pageControl.currentPage]];

    
    
    
}

- (void)loadScrollViewWithPage:(int)page {
    
    if (page < 0) return;
    if (page >= [self numberOfPages]) return;
	NSString *fileName = [[self.content objectAtIndex:page] objectForKey:@"img"];
    CSAsyncImageView *imgView = [self.viewsArray objectAtIndex:page];
    if ((NSNull *)imgView == [NSNull null]) {
        imgView = [[CSAsyncImageView alloc] initWithFrame:self.sView.frame];
		[imgView loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,fileName]] andName:fileName] ;
        [self.viewsArray replaceObjectAtIndex:page withObject:imgView];
    }
	
    if (nil == imgView.superview) {
        CGRect frame = self.sView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        imgView.frame = frame;
        [self.sView addSubview:imgView];
    }
}

-(int)numberOfPages
{
	return  (int)[self.content count];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (pageControlUsed) {
        return;
    }
    CGFloat pageWidth = self.sView.frame.size.width;
    int page = floor((self.sView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	self.pageControl.currentPage = page;
    [self loadScrollViewWithPage:page];
    
    
	
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if(oldPageNumber2<self.pageControl.currentPage &&oldPageNumber2-1>0)
	{
		[self.viewsArray replaceObjectAtIndex:oldPageNumber2-1 withObject:[NSNull null]];
	}
	else if (oldPageNumber2>self.pageControl.currentPage && oldPageNumber2+1<[self numberOfPages])
	{
		[self.viewsArray replaceObjectAtIndex:oldPageNumber2+1 withObject:[NSNull null]];
	}
    
    
    [self loadDetails:[self.content objectAtIndex:self.pageControl.currentPage]];
    pageControlUsed = NO;
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)sender{
	oldPageNumber2= (int)self.pageControl.currentPage;
}

- (void)changePage:(int)sender {
    
    int page = sender;
    
    NSLog(@"pg %d",page);
    
    if (page > 0) [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    if (page < kNumberOfPages-1)[self loadScrollViewWithPage:page + 1];
    
    // update the scroll view to the appropriate page
    CGRect frame = self.sView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.sView scrollRectToVisible:frame animated:YES];
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    self.pageControl.currentPage = page;
    
    
 //   pageControlUsed = YES;
}


#pragma Set Comment

-(void)setCommentRequest:(id)sender{
    @autoreleasepool {
        NSString *url = [NSString stringWithFormat:@"%@",SetImageComment];
        
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
        

        NSDictionary *currentObject = [self.content objectAtIndex:self.pageControl.currentPage];
        
        
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"img_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:[currentObject objectForKey:@"img_id"]] dataUsingEncoding:NSUTF8StringEncoding]];
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
    
    [self performSelectorInBackground:@selector(getImageDetailsRequest:) withObject:nil];
}

-(void)setCommentsError:(id)sender{
    [pService OnEndRequest];
}

-(void)loadDetails:(NSDictionary*)imageContent{
    
    NSLog(@"rty %@",imageContent);
    
    [self.description setTitle:[NSString stringWithFormat:@"%@",[imageContent objectForKey:@"description"]] forState:UIControlStateNormal];
    self.selectionImageID = [imageContent objectForKey:@"img_id"];
    
    if ([[imageContent objectForKey:@"like"] intValue] == 1)self.likes.text = @"1 people like this";
    else if ([[imageContent objectForKey:@"like"] intValue] == 0)self.likes.text = @"0 people like this";
    else self.likes.text = [NSString stringWithFormat:@"%d people like this",[[imageContent objectForKey:@"like"] intValue]];
    
    if ([[imageContent objectForKey:@"liked"] isEqualToString:@"false"])self.likedImage.image = [UIImage imageNamed:@"like.png"];
    else self.likedImage.image = [UIImage imageNamed:@"liked.png"];
    
    if ([[imageContent objectForKey:@"like"] intValue] == 0)self.likedImage.image = [UIImage imageNamed:@"like.png"];
    
    [self.calendarUserButton setTitle:[NSString stringWithFormat:@"%@",[imageContent objectForKey:@"username"]] forState:UIControlStateNormal];
    
    [self.userImage loadFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,[imageContent objectForKey:@"profile_img"]]]];
    


    if ([[imageContent objectForKey:@"id"] isEqualToString:ownID()]){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deletePhoto:)];
        self.navigationItem.rightBarButtonItem = nil;
    }
    else self.navigationItem.rightBarButtonItem = nil;
    
    [self performSelectorInBackground:@selector(getImageDetailsRequest:) withObject:nil];
    
    if ((int)self.pageControl.currentPage == 0)self.left.hidden = YES;
    else self.left.hidden = NO;
    
    if ((int)self.pageControl.currentPage == self.content.count-1)self.right.hidden = YES;
    else self.right.hidden = NO;
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 11){
        if (buttonIndex == 1) {
            [pService OnStartRequest];
            [self performSelectorInBackground:@selector(deleteImageRequest:) withObject:nil];
        }
    }
    
}

#pragma Delete Photo
-(void)deletePhoto:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete?" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No",@"Yes", nil];
    alert.tag = 11;
    [alert show];
    
}

-(void)deleteImageRequest:(id)sender{
    @autoreleasepool {
        NSString *url = [NSString stringWithFormat:@"%@&token=%@&img_id=%@",DeleteImage,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],self.selectionImageID];
        
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        ////NSLog(@"%@",returnString);
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            
            [self performSelectorOnMainThread:@selector(deleteSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(deleteError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
}

-(void)deleteSuccess:(id)sender{

    if (self.content > 0){
        self.currentSelection = 0;
        NSMutableArray *views = [[NSMutableArray alloc] init];
        int pagesNo = (int)[self.content count];
        for (unsigned i = 0; i < [self.content count]; i++) {
            [views addObject:[NSNull null]];
        }
        self.viewsArray = views;
        
        self.sView.pagingEnabled = YES;
        self.sView.showsHorizontalScrollIndicator = NO;
        self.sView.showsVerticalScrollIndicator = NO;
        self.sView.scrollsToTop = NO;
        self.sView.delegate = self;
        self.sView.contentSize = CGSizeMake(self.sView.frame.size.width*pagesNo, 260);
        self.pageControl = [[UIPageControl alloc]init];
        self.pageControl.numberOfPages = pagesNo;
        self.pageControl.currentPage = self.currentSelection;
        
        
        
        kNumberOfPages = (int)self.content.count;
        [self changePage:self.currentSelection];
        [self loadDetails:[self.content objectAtIndex:self.pageControl.currentPage]];

    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [pService OnEndRequest];
}

-(void)deleteError:(id)sender{
    [pService OnEndRequest];
}


#pragma Get ImageDetails

-(void)getImageDetailsRequest:(id)sender{
    @autoreleasepool {
        NSString *url = [NSString stringWithFormat:@"%@&token=%@&img_id=%@",GetImageDetails,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],self.selectionImageID];

        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        ////NSLog(@"%@",returnString);
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            NSLog(@"xxxx %@",dict);
            self.commentsContent = [[NSMutableArray alloc]initWithArray:(NSArray*)[[dict objectForKey:@"response"]objectForKey:@"profile"]];
            [self performSelectorOnMainThread:@selector(getImageDetailsSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(getImageDetailsError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
}

-(void)getImageDetailsSuccess:(id)sender{
    
    NSMutableArray *toRemove = [[NSMutableArray alloc]init];
    
    for (NSDictionary *comm in self.commentsContent) {
        NSString *string = [comm objectForKey:@"comment"];
        if ([string rangeOfString:@"likes your photo"].location == NSNotFound) {
            
            
            if ([string rangeOfString:@"is following you"].location == NSNotFound){
                //NSLog(@"%d normal",indexPath.row);
            }
            else {
                [toRemove addObject:comm];
            }
        }
        else {
            [toRemove addObject:comm];
        }
    }
    [self.commentsContent removeObjectsInArray:toRemove];
    
    [self.table reloadData];
    
    
    
    
//    if (self.commentsContent.count == 0) {
//        self.noComments.hidden = NO;
//    }
//    else
        self.noComments.hidden = YES;
    [pService OnEndRequest];
}

-(void)getImageDetailsError:(id)sender{
    [pService OnEndRequest];
}


#pragma UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentsContent.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"CellIdentifier";
    
    PictureCommentsCell *cell = (PictureCommentsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil){
        cell = [[PictureCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.userImage loadImage:[UIImage imageNamed:@"img.png"]];
    [cell.userImage loadImageFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,[[self.commentsContent objectAtIndex:indexPath.row] objectForKey:@"profile_img"]]] andName:[[self.commentsContent objectAtIndex:indexPath.row] objectForKey:@"profile_img"]];
    cell.username.text = [[self.commentsContent objectAtIndex:indexPath.row] objectForKey:@"username"];
    
    
    NSString * cellText = [[self.commentsContent objectAtIndex:indexPath.row] objectForKey:@"comment"];
    
    
    UIFont *cellFont = [UIFont fontWithName:@"HelveticaNeue" size:12];
    CGSize constraintSize = CGSizeMake(265.0f, MAXFLOAT);
    
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    cell.content.frame = CGRectMake(50, 20, 265, labelSize.height);
    cell.content.text = cellText;
    
    CALayer *bottomBorder = [CALayer layer];
    if (labelSize.height < 20) bottomBorder.frame = CGRectMake(0.0f, 43, cell.frame.size.width, 1.0f);
    else bottomBorder.frame = CGRectMake(0.0f, labelSize.height + 31, cell.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0].CGColor;
  //  [cell.layer addSublayer:bottomBorder];

    NSLog(@"%@",[self.commentsContent objectAtIndex:indexPath.row]);
    
    NSString *dateString = [NSString stringWithFormat:@"%@ %@",[[self.commentsContent objectAtIndex:indexPath.row] objectForKey:@"day"],[[self.commentsContent objectAtIndex:indexPath.row] objectForKey:@"hour"]];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc]init];
    [formatDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [formatDate dateFromString:dateString];
    cell.time.text = [currentDate timeAgoSinceNow];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * cellText = [[self.commentsContent objectAtIndex:indexPath.row] objectForKey:@"comment"];
    
    UIFont *cellFont = [UIFont fontWithName:@"HelveticaNeue" size:12];
    CGSize constraintSize = CGSizeMake(265.0f, MAXFLOAT);
    
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    if (labelSize.height < 20) return 44;
    return labelSize.height + 23;
    
    
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ////NSLog(@"dddd");
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    delegate.user_id = [[self.commentsContent objectAtIndex:indexPath.row]objectForKey:@"id"];

        CalendarViewController *calendar = [[CalendarViewController alloc]init];
        calendar.comesFromFollwers = 1;
        [self.navigationController pushViewController:calendar animated:YES];
    
    return indexPath;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
