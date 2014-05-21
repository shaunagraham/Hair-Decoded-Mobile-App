//
//  CreateProfileViewController.m
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "ProfileViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pService = [WebServiceWrapper sharedWebServiceWrapper];
    }
    return self;
}

-(void)cropImage:(UIImage *)img{
    
    self.selectedImage.image = img;
}

- (IBAction)gender_male:(id)sender {
    self.genderImage.image = [UIImage imageNamed:@"M_F1.png"];
}
- (IBAction)gender_female:(id)sender {
    self.genderImage.image = [UIImage imageNamed:@"M_F3.png"];
    
}

- (IBAction)private:(id)sender {
    UISwitch *s = (UISwitch*)sender;
    if (s.isOn)self.isPrivate = @"1";
    else self.isPrivate = @"0";
}



- (IBAction)selectImage:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"Select Profile Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose from Library", nil];
    action.tag = 1;
    [action showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1){
        //photo
        
        if (buttonIndex == 0){
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }
        else if (buttonIndex == 1){
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }
        
    }
    if (actionSheet.tag == 2){
        self.hairType.tag = buttonIndex + 1;
        if (buttonIndex == 0){
            self.hairType.text = @"Straight";
            
        }
        else if (buttonIndex == 1){
            self.hairType.text = @"Wavy";
        }
        else if (buttonIndex == 2){
            self.hairType.text = @"Curly";
        }
        else if (buttonIndex == 3){
            self.hairType.text = @"Kinky";
        }
        
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    ////NSLog(@"%@",info);
    if ([[info objectForKey:@"UIImagePickerControllerMediaType"] isEqual:@"public.image"])
    {
        
        self.croppedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        self.selectedImage.image = self.croppedImage;
        
        [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)animationCompleted{
    CropImageViewController *crop = [[CropImageViewController alloc]init];
    crop.img = self.croppedImage;
    crop.delegate = self;
    [self presentViewController:crop animated:YES completion:nil];
}



-(IBAction)profileDone:(id)sender{
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_logged"] boolValue]){
        
        [pService OnStartRequest];
        [self performSelectorInBackground:@selector(createProfileRequest:) withObject:nil];
    }
    else {
        [pService OnStartRequest];
        [self performSelectorInBackground:@selector(updateProfileRequest:) withObject:nil];
    }
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.hairType){
        [self.hairType resignFirstResponder];
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Hair Type" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Straight",@"Wavy",@"Curly",@"Kinky", nil];
        sheet.tag = 2;
        [sheet showInView:self.view];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger insertDelta = string.length - range.length;
    
    if (textField.text.length + insertDelta > 20)
    {
        return NO; // return NO to not change text
    }
    
    return YES;
}

-(void)updateProfile:(NSDictionary*)profile{
    
    [self.selectedImage loadFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,[profile objectForKey:@"profile_img"]]]];
    self.username.text = [profile objectForKey:@"username"];
    self.aboutMe.text = [profile objectForKey:@"describe"];
    self.aboutText = [profile objectForKey:@"describe"];
    [[NSUserDefaults standardUserDefaults] setValue:[profile objectForKey:@"id"] forKey:@"hairdecoded_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    if (![self.aboutText isEqualToString:@""])self.defaultLabel.hidden = YES;
        
    self.hairType.text = [[profile objectForKey:@"hair_type"] capitalizedString];
    
    if ([[profile objectForKey:@"gender"] isEqualToString:@"male"]){
        self.genderImage.image = [UIImage imageNamed:@"M_F1.png"];
    }
    else {
        self.genderImage.image = [UIImage imageNamed:@"M_F3.png"];
    }
    
    if ([[profile objectForKey:@"private"] boolValue] == 0){
        [self.privateSwitch setOn:NO];
        self.isPrivate = @"0";
    }
    else {
        [self.privateSwitch setOn:YES];
        self.isPrivate = @"1";
    }
    
    NSArray * directoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * pathPlist = [NSString stringWithFormat:@"%@/user.plist",[directoryPath objectAtIndex:0]];
    NSURL * urlPlist = [NSURL fileURLWithPath:pathPlist];
    [profile writeToURL:urlPlist atomically:NO];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.defaultLabel.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)txtView
{
    self.defaultLabel.hidden = ([txtView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)txtView
{
    self.defaultLabel.hidden = ([txtView.text length] > 0);
    self.aboutText = self.aboutMe.text;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger insertDelta = text.length - range.length;
    
    if (textView.text.length + insertDelta > 120)
    {
        return NO; // return NO to not change text
    }
    else
    {
    
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    }
    
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    x = 1;
    
    if (!IS_IPHONE_5) {
        self.createButton.frame = CGRectMake(self.createButton.frame.origin.x, self.createButton.frame.origin.y-100, self.createButton.frame.size.width, self.createButton.frame.size.height);
    }
    
    
    [self.aboutMe.layer setMasksToBounds:YES];
	[self.aboutMe.layer setCornerRadius:5.0];
    [self.aboutMe.layer setBorderWidth:1.0];
    [self.aboutMe.layer setBorderColor:commonColor.CGColor];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.backBarButtonItem = nil;
    self.navigationController.navigationBar.tintColor = commonColor;
    
    if (self.isInitial){
        self.navigationItem.title = @"Create Profile";
        [self.createButton setTitle:@"Create Profile" forState:UIControlStateNormal];
        if ([self.app_code isEqualToString:@"twitter"]){
            [self.selectedImage loadFromURL:[NSURL URLWithString:[self.userInfo objectForKey:@"urlImage"]]];
        }
        else {
                    [self.selectedImage loadFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=260&height=260&access_token=%@",[self.userInfo objectForKey:@"id"],[FBSession.activeSession accessTokenData].accessToken]]];
        }

        self.username.text = [self.userInfo objectForKey:@"username"];
        if ([[self.userInfo objectForKey:@"gender"] isEqualToString:@"male"]){
            self.genderImage.image = [UIImage imageNamed:@"M_F1.png"];
        }
        else self.genderImage.image = [UIImage imageNamed:@"M_F3.png"];
        self.isPrivate = @"0";
    }
    else {
        [[UIBarButtonItem appearance] setTintColor:commonColor];
        self.navigationController.navigationBar.tintColor = commonColor;
        self.navigationItem.title = @"Profile";
        [self.createButton setTitle:@"Update Profile" forState:UIControlStateNormal];
        [pService OnStartRequest];
        [self performSelectorInBackground:@selector(getProfileRequest:) withObject:nil];
        
        NSArray * directoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * pathPlist = [NSString stringWithFormat:@"%@/user.plist",[directoryPath objectAtIndex:0]];
        NSURL * urlPlist = [NSURL fileURLWithPath:pathPlist];
        NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfURL:urlPlist];
        
        [self updateProfile:dict];
    }
    
    self.croppedImage = nil;
    
    if (self.hairTypeSelected == 1)self.hairType.text = @"Straight";
    if (self.hairTypeSelected == 2)self.hairType.text = @"Wavy";
    if (self.hairTypeSelected == 3)self.hairType.text = @"Curly";
    if (self.hairTypeSelected == 4)self.hairType.text = @"Kinky";
    
    
    
    self.imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.delegate = self;
    
    
    
    [self.createButton.layer setMasksToBounds:YES];
	[self.createButton.layer setCornerRadius:5.0];
    self.createButton.backgroundColor = commonColor;
    


}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma Get Profile

-(void)getProfileRequest:(id)sender{
    @autoreleasepool {
        NSString *url = [NSString stringWithFormat:@"%@&token=%@",GetProfile,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"]];
        
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        ////NSLog(@"%@",returnString);
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            
            NSArray * directoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * pathPlist = [NSString stringWithFormat:@"%@/user.plist",[directoryPath objectAtIndex:0]];
            NSURL * urlPlist = [NSURL fileURLWithPath:pathPlist];
            [[dict objectForKey:@"response"] writeToURL:urlPlist atomically:NO];
            
            
            [self performSelectorOnMainThread:@selector(getProfileSuccess:) withObject:dict waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(getProfileError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
}

-(void)getProfileSuccess:(id)sender{
    NSDictionary *dict = (NSDictionary*)sender;
    [self updateProfile:[dict objectForKey:@"response"]];
    
    [pService OnEndRequest];
    
    if (x == 2){
        ShowMessageBox(@"Profile updated.", @"", -1, nil);
        x = 1;
    }
}

-(void)getProfileError:(id)sender{
    [pService OnEndRequest];
    ShowMessageBox(@"Error", @"Something went wrong. Please try again", -1, nil);

}



#pragma Create User 
-(void)createProfileRequest:(id)sender{
    @autoreleasepool {
        NSString *url = [NSString stringWithFormat:@"%@",Register];
        
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        
        
        NSString *mpfBoundry = @"-----------------------------7d91191f100ca";
        [request setValue:[NSString stringWithFormat:@"multipart/form-data, boundary=%@",mpfBoundry] forHTTPHeaderField:@"Content-Type"];
        NSMutableData *postbody = [NSMutableData data];
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"app_code\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:self.app_code] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"api_user_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:[self.userInfo objectForKey:@"id"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:[self.userInfo objectForKey:@"username"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:[self.userInfo objectForKey:@"email"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"gender\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:[self.userInfo objectForKey:@"gender"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"hair_type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:[self.hairType.text lowercaseString]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"describe\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:[NSString stringWithFormat:@"%@ ",self.aboutMe.text]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"private\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:self.isPrivate] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"profileimage.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[NSData dataWithData:UIImageJPEGRepresentation(self.selectedImage.image, 1.0)]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        [request setHTTPBody:postbody];
        
     //   NSString *strData = [[NSString alloc]initWithData:postbody encoding:NSUTF8StringEncoding];
        ////NSLog(@"str %@",strData);
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        
        
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",returnString);
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"hairdecoded_logged"];
            [[NSUserDefaults standardUserDefaults] setValue:[[dict objectForKey:@"response"] objectForKey:@"token"] forKey:@"hairdecoded_token"];
            [[NSUserDefaults standardUserDefaults] setValue:[[dict objectForKey:@"response"] objectForKey:@"id"] forKey:@"hairdecoded_id"];
            [[NSUserDefaults standardUserDefaults] setValue:[[dict objectForKey:@"reason"] objectForKey:@"username"] forKey:@"hairdecoded_username"];
            [[NSUserDefaults standardUserDefaults] setValue:[[dict objectForKey:@"reason"] objectForKey:@"profile_img"] forKey:@"hairdecoded_profile_img"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            NSArray * directoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * pathPlist = [NSString stringWithFormat:@"%@/user.plist",[directoryPath objectAtIndex:0]];
            NSURL * urlPlist = [NSURL fileURLWithPath:pathPlist];
            [[[dict objectForKey:@"response"] objectForKey:@"profile"] writeToURL:urlPlist atomically:NO];
            
            [self performSelectorOnMainThread:@selector(registerSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(registerError:) withObject:nil waitUntilDone:YES];
            
        }
        
        
    }
}

-(void)registerSuccess:(id)sender{
    [pService OnEndRequest];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logged" object:nil];
}

-(void)registerError:(id)sender{
    [pService OnEndRequest];
    ShowMessageBox(@"Error", @"Something went wrong. Please try again", -1, nil);
    
}


#pragma UpdateProfile

-(void)updateProfileRequest:(id)sender{
    @autoreleasepool {
        NSString *url = [NSString stringWithFormat:@"%@",UpdateProfile];
        
        
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
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:self.username.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *gender = @"";
        if ([self.genderImage.image isEqual:[UIImage imageNamed:@"M_F1.png"]])gender = @"male";
        else gender = @"female";
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"gender\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:gender] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"hair_type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:[self.hairType.text lowercaseString]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"describe\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:self.aboutMe.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"private\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[@"0" dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"profileimg.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[NSData dataWithData:UIImageJPEGRepresentation(self.selectedImage.image, 1.0)]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        [request setHTTPBody:postbody];
        
      //  NSString *strData = [[NSString alloc]initWithData:postbody encoding:NSUTF8StringEncoding];
        ////NSLog(@"str %@",strData);
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        
        
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",returnString);
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){

            
            
            [self performSelectorOnMainThread:@selector(updateSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(updateError:) withObject:nil waitUntilDone:YES];
            
        }
        
        
    }
}

-(void)updateSuccess:(id)sender{
    x = 2;
    [self performSelectorInBackground:@selector(getProfileRequest:) withObject:nil];
}

-(void)updateError:(id)sender{
    [pService OnEndRequest];
    ShowMessageBox(@"Error", @"Something went wrong. Please try again", -1, nil);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
