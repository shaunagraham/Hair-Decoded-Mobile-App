//  UIImageView+Cached.h
//

#import "UIImageView+Cached.h"

#pragma mark -
#pragma mark --- Threaded & Cached image loading ---

@implementation UIImageView (Cached)

#define MAX_CACHED_IMAGES 350	// max # of images we will cache before flushing cache and starting over

// method to return a static cache reference (ie, no need for an init method)
-(NSMutableDictionary*)cache
{
	static NSMutableDictionary* _cache = nil;
	
	if( !_cache )
		_cache = [NSMutableDictionary dictionaryWithCapacity:MAX_CACHED_IMAGES];
    
	assert(_cache);
	return _cache;
}

// Loads an image from a URL, caching it for later loads
// This can be called directly, or via one of the threaded accessors
-(void)cacheFromURL:(NSURL*)url
{
    
	UIImage* newImage = [[self cache] objectForKey:url.description];
	if( !newImage )
	{
        NSString *urlString = [url absoluteString];
        NSArray *content = [urlString componentsSeparatedByString:@"/"];
        BOOL fileExists = false;
        if (content.count > 0){
            NSString *name = [content objectAtIndex:content.count-1];
            NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@",docs,[NSString stringWithFormat:@"%@",name]];
            
            fileExists = [[NSFileManager defaultManager] fileExistsAtPath:pngFilePath];
            if (fileExists){
                [[self cache] setValue:newImage forKey:url.description];
                newImage = [UIImage imageWithContentsOfFile:pngFilePath];
                [self performSelectorOnMainThread:@selector(setImage:) withObject:newImage waitUntilDone:NO];
                NSLog(@"imagine gasita");
            }
        }
        
        
        if (!fileExists){
		@autoreleasepool {
            NSError *err = nil;
            NSLog(@"download");
            NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&err];
            newImage = [UIImage imageWithData: data] ;
            if( newImage )
            {
                // check to see if we should flush existing cached items before adding this new item
                if( [[self cache] count] >= MAX_CACHED_IMAGES )
                    [[self cache] removeAllObjects];
                
                [[self cache] setValue:newImage forKey:url.description];
            }
            
            

            
            if (content.count > 0){
                NSString *name = [content objectAtIndex:content.count-1];
                NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@",docs,[NSString stringWithFormat:@"%@",name]];
                [data writeToFile:pngFilePath atomically:NO];
            }
            
        }
        }
	}
    
	if( newImage ){
        [self performSelectorOnMainThread:@selector(setImage:) withObject:newImage waitUntilDone:NO];
    }
    else [self performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"dummy.png"] waitUntilDone:NO];
}

// Methods to load and cache an image from a URL on a separate thread
-(void)loadFromURL:(NSURL *)url
{
	[self performSelectorInBackground:@selector(cacheFromURL:) withObject:url];
}

-(void)loadFromURL:(NSURL*)url afterDelay:(float)delay
{
	[self performSelector:@selector(loadFromURL:) withObject:url afterDelay:delay];
}

@end
