#import "CSAsyncImageView.h"
#define docs [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


@implementation CSAsyncImageView


- (void)loadImageFromURL:(NSURL*)url andName:(NSString*)name {
//	if (lastUrl!=nil && [[url absoluteString] isEqual:[lastUrl absoluteString]]) {
//		return;
//	}

	
	NSString *pathToDefaultPlist = [docs stringByAppendingPathComponent:@"images.plist"];
	NSURL *urlx =[NSURL fileURLWithPath:pathToDefaultPlist];
	NSMutableArray *content=[[NSMutableArray alloc]initWithContentsOfURL:urlx];
	int x = -1;
	
	for (int  i = 0; i < content.count; i++ )
		if ([[[content objectAtIndex:i]objectForKey:@"url"] isEqualToString:[url absoluteString]]){x = i; break;}
	
	if(x == -1)
	{
		numeImagine = name;
		NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[url absoluteString],@"url",name,@"name",nil];
		[content addObject:dict];
		[content writeToURL:urlx atomically:NO];
	}
	
	if(lastUrl!=nil)
	{
		lastUrl = nil;
	}
	
	lastUrl = url;
	
	if ([self viewWithTag:100]) {
			//then this must be another image, the old one is still in subviews
		[[self viewWithTag:100] removeFromSuperview]; //so remove it (releases it also)
	}
	
	if (activityIndicator!=nil) {
			//then this must be another image, the old one is still in subviews
		[activityIndicator removeFromSuperview]; //so remove it (releases it also)
		activityIndicator=nil;
	}
	
	if (activityIndicator==nil) {
		activityIndicator = [[UIActivityIndicatorView alloc] init];
		activityIndicator.frame = CGRectMake((self.frame.size.width/2)-10, (self.frame.size.height/2)-10, 20, 20);
		[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
		[activityIndicator startAnimating];
		[self addSubview:activityIndicator];
		activityIndicator.tag = 101;
	}
	
	activityIndicator.hidden = NO;
	
	if (connection!=nil) 
	{ 
		activityIndicator.hidden = YES;
		[connection cancel];
		connection = nil;
	}
	if (data!=nil) 
	{ 
		data = nil;
	}
	
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; //notice how delegate set to self object
		//	 }	
			//TODO error handling, what if connection is nil?
}


	//the URL connection calls this repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data==nil) { data = [[NSMutableData alloc] initWithCapacity:2048]; } 
	[data appendData:incrementalData];
//	NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@",docs,numeImagine];
//	UIImage *image = [[UIImage alloc] initWithData:data];
//	NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
//	[imageData writeToFile:pngFilePath atomically:YES];
}

	//the URL connection calls this once all the data has downloaded
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
		//so self data now has the complete image 
	[activityIndicator removeFromSuperview];
	activityIndicator = nil;
	
	connection=nil;
	if ([self viewWithTag:100]) {
			//then this must be another image, the old one is still in subviews
		[[self viewWithTag:100] removeFromSuperview]; //so remove it (releases it also)
	}
	
		//make an image view for the image
	
	UIImage *img = [[UIImage alloc] initWithData:data];
	
	[self loadImage:img];

	data=nil;
}
-(void)loadImage:(UIImage*)img
{
	UIImageView* imageView = [[UIImageView alloc] initWithImage:img];

	//[img release];
	//make sizing choices based on your needs, experiment with these. maybe not all the calls below are needed.
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth );
	for (UIView*x in [self subviews])
		[x removeFromSuperview];
	[self addSubview:imageView];
	imageView.frame = self.bounds;
	imageView.tag = 100;
	
	[imageView setNeedsLayout];
	[self setNeedsLayout];
	
}
	//just in case you want to get the image directly, here it is in subviews
- (UIImage*) image {
	UIImageView* iv = [[self subviews] objectAtIndex:0];
	return [iv image];
}


@end
