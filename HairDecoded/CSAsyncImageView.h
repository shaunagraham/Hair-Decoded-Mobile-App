#import <UIKit/UIKit.h>

// downloads an image from a url, if the image is already downloaded the image is loaded from bundle
// while the download takes place a activity indicator is present to alert user that the image is still downloading
@interface CSAsyncImageView : UIView {
	NSURLConnection* connection;
	NSMutableData* data;
	
	UIActivityIndicatorView* activityIndicator;
	NSString *numeImagine;   // image name
	NSURL* lastUrl; // url 
}
-(void)loadImage:(UIImage*)img; // loads image from bundle
-(void)loadImageFromURL:(NSURL*)url andName:(NSString*)name; // downloads image from url and saves it with the "name".png in bundle
-(UIImage*) image;

@end
