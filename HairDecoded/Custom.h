//
//  Custom.h
//  Limetree
//
//  Created by George Burduhos on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "WebServiceWrapper.h"
#import "JSON.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIImageView+Cached.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"


// color define
#define BLUEFACEBOOKCOLOR [UIColor colorWithRed:35/255.0 green:50/255.0 blue:116/255.0 alpha:1.0]


inline static NSString *encodeString(NSString* candidate)
{
    
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (CFStringRef)candidate,
                                                                                 NULL,
                                                                                 (CFStringRef)@"",
                                                                                 kCFStringEncodingUTF8 ));
}

inline static NSString *decodeString(NSString* candidate)
{
    return (NSString *)[candidate stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
inline static NSString* ownID(){
    
    NSLog(@"own id %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_id"]);
    return [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_id"]] ;
}


inline static NSMutableArray* GetComm()
{
    @autoreleasepool {
        NSString *url = [NSString stringWithFormat:@"%@&token=%@&id=%@",GetComments,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],ownID()];
        
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            
            return  [[NSMutableArray alloc]initWithArray:(NSArray*)[[dict objectForKey:@"response"] objectForKey:@"profile"]];
        }
        else {
            return nil;
        }
        
        
    }
}


inline static NSInteger ageFromString(NSString *dateString, NSString *dateFormat){
    
    if ([dateString isEqualToString:@"0000-00-00"])return 0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:dateFormat];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *dateComponentsNow = [calendar components:flags fromDate:[NSDate date]];
    NSDateComponents *dateComponentsBirth = [calendar components:flags fromDate:[dateFormatter dateFromString:dateString]];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) || (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
        return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
    } else {
        return [dateComponentsNow year] - [dateComponentsBirth year];
    }

}

inline static NSString* interestedIn (NSString *string){
    
    if ([string intValue] == 1)return @"Men";
    if ([string intValue] == 2)return @"Women";
    return @"Surprise Me";
}

inline static UILabel* attributedTitle (NSString *text){
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:21];
    titleLabel.textColor = [UIColor colorWithRed:253/255.0 green:91/255.0 blue:83/255.0 alpha:1.0];
    titleLabel.text = text;
    NSMutableAttributedString *attributedString;
    attributedString = [[NSMutableAttributedString alloc] initWithString:titleLabel.text];
    [attributedString addAttribute:NSKernAttributeName value:@3 range:NSMakeRange(0, [titleLabel.text length])];
    [titleLabel setAttributedText:attributedString];
    
    return titleLabel;
}


inline static void sendPushNotificationToUserWithMessage(NSString *user_id, NSString *message){
    
}

inline static NSString* userContent(NSString *key){
    NSString *pathToDefaultPlist = [docs stringByAppendingPathComponent:@"user.plist"];
    NSURL *urlxx =[NSURL fileURLWithPath:pathToDefaultPlist];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithContentsOfURL:urlxx];
    return [dictionary objectForKey:key];
}



inline static NSString* token(){
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"];
}
inline static NSString* username(){
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_username"];
}
inline static NSString* profile_img(){
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_profile_img"];
}





inline static void ShowMessageBox(NSString* title, NSString* body, NSInteger tag, id dlg)
{
	UIAlertView *baseAlert = [[UIAlertView alloc]initWithTitle:title  message:body delegate:dlg cancelButtonTitle:nil  otherButtonTitles:@"OK",nil];
	[baseAlert setTag:tag];
	[baseAlert show];	
}

inline static void ShowMessageError()
{
    UIAlertView *baseAlert = [[UIAlertView alloc]initWithTitle:@"Sorry, you do not have an internet connection, the latest data might not be available"  message:@"" delegate:nil cancelButtonTitle:nil  otherButtonTitles:@"OK",nil];
	[baseAlert setTag:-1];
	[baseAlert show];

}


inline static BOOL validateEmail(NSString * candidate )
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 	
    return [emailTest evaluateWithObject:candidate];
}
inline static BOOL validateMatchesConfirmation(NSString * candidate, NSString * confirmation)
{
    return [candidate isEqualToString:confirmation];
}

inline static BOOL validateMinimumLength(NSString * candidate , int length)
{
    return ([candidate length] >= length) ? YES : NO;
}

inline static BOOL isLoggedIn()
{
    
    BOOL value;
    NSString *pathToDefaultPlist = [docs stringByAppendingPathComponent:@"database.plist"];
    NSURL *urlxx =[NSURL fileURLWithPath:pathToDefaultPlist];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithContentsOfURL:urlxx]; 
    
    if ([[dictionary objectForKey:@"login"] isEqualToString:@"YES"]){
        value =  YES;
        
    }
    else {
        value =  NO;
    }

    return value;
    
}

inline static NSMutableDictionary* dictionaryByReplacingNullsWithStrings(NSDictionary *candidate) {
    
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: candidate];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in candidate) {
        const id object = [candidate objectForKey: key];
        if (object == nul) {
            [replaced setObject: blank forKey: key];
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: dictionaryByReplacingNullsWithStrings(object) forKey: key];
        }
    }
    return [NSMutableDictionary dictionaryWithDictionary: replaced];
}


inline static NSString* dateFromJSONString(NSString *candidate){
    candidate = [candidate stringByReplacingOccurrencesOfString:@"/Date("
                                                           withString:@""];
    candidate = [candidate stringByReplacingOccurrencesOfString:@")/"
                                                           withString:@""];
    
    unsigned long long milliseconds = [candidate longLongValue];
    NSTimeInterval interval = milliseconds/1000;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *dfMyTime = [[NSDateFormatter alloc] init];
    [dfMyTime setDateStyle:NSDateFormatterLongStyle];
    
    return [dfMyTime stringFromDate:date];

}

inline static NSString* removeWhiteSpace(NSString *candidate){
    return [candidate stringByReplacingOccurrencesOfString:@" " withString:@""];
}

inline static void ShowMessageInfo(NSString* title, NSInteger tag, id dlg)
{
	UIAlertView *baseAlert = [[UIAlertView alloc]initWithTitle:title  message:nil delegate:dlg cancelButtonTitle:nil  otherButtonTitles:nil,nil];
	[baseAlert setTag:tag];
	[baseAlert show];
}
