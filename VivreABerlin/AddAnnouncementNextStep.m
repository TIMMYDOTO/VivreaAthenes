//
//  AddAnnouncementNextStep.m
//  VivreABerlin
//
//  Created by home on 19/08/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "AddAnnouncementNextStep.h"
#import "OLGhostAlertView.h"
#import "GlobalVariables.h"
#import "JTMaterialSpinner.h"
#import "Reachability.h"
#import "Header.h"

@interface AddAnnouncementNextStep ()

@end

@implementation AddAnnouncementNextStep
{
    int buttonClicked;
    NSMutableDictionary *chosenImages;
    JTMaterialSpinner *spinnerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    
    chosenImages = [[NSMutableDictionary alloc] init];
    
    buttonClicked = 0;
    
    self.nextBigView.layer.cornerRadius = 5;
    self.nextBigView.clipsToBounds = true;
    self.bigTitle.layer.cornerRadius = 3;
    self.bigTitle.clipsToBounds = true;
    
    self.imageNo1.contentMode = UIViewContentModeScaleAspectFill;
    self.imageNo1.clipsToBounds = true;
    self.imageNo2.contentMode = UIViewContentModeScaleAspectFill;
    self.imageNo2.clipsToBounds = true;
    self.imageNo3.contentMode = UIViewContentModeScaleAspectFill;
    self.imageNo3.clipsToBounds = true;
    self.imageNo4.contentMode = UIViewContentModeScaleAspectFill;
    self.imageNo4.clipsToBounds = true;
    self.imageNo5.contentMode = UIViewContentModeScaleAspectFill;
    self.imageNo5.clipsToBounds = true;
    
    
    UIFont *arialFont = [UIFont fontWithName:@"Montserrat-Light" size:14.0];
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: arialFont forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:@"Vous pouvez charger " attributes: arialDict];
    
    UIFont *VerdanaFont = [UIFont fontWithName:@"Montserrat-Bold" size:14.0];
    NSDictionary *verdanaDict = [NSDictionary dictionaryWithObject:VerdanaFont forKey:NSFontAttributeName];
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString: @"5" attributes:verdanaDict];
    
    UIFont *MonsterratFont = [UIFont fontWithName:@"Montserrat-Light" size:14.0];
    NSDictionary *monsterratFont = [NSDictionary dictionaryWithObject:MonsterratFont forKey:NSFontAttributeName];
    NSMutableAttributedString *zAttrString = [[NSMutableAttributedString alloc]initWithString: @" images de " attributes:monsterratFont];
    
    UIFont *iarAltFont = [UIFont fontWithName:@"Montserrat-Bold" size:14.0];
    NSDictionary *IaltFont = [NSDictionary dictionaryWithObject:iarAltFont forKey:NSFontAttributeName];
    NSMutableAttributedString *pAttrString = [[NSMutableAttributedString alloc]initWithString: @"1 MB " attributes:IaltFont];
    
    UIFont *AltFont = [UIFont fontWithName:@"Montserrat-Light" size:14.0];
    NSDictionary *altFont = [NSDictionary dictionaryWithObject:AltFont forKey:NSFontAttributeName];
    NSMutableAttributedString *lAttrString = [[NSMutableAttributedString alloc]initWithString: @"maxi chacune" attributes:altFont];
    
    //    [aAttrString appendAttributedString:vAttrString];
    //    [zAttrString appendAttributedString:aAttrString];
    //    [pAttrString appendAttributedString:zAttrString];
    //    [lAttrString appendAttributedString:pAttrString];
    
    [pAttrString appendAttributedString:lAttrString];
    [zAttrString appendAttributedString:pAttrString];
    [vAttrString appendAttributedString:zAttrString];
    [aAttrString appendAttributedString:vAttrString];
    
    
    self.photoDesc.attributedText = aAttrString;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)addImages:(id)sender {
    
    
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    switch (status) {
        case ALAuthorizationStatusNotDetermined: {
            // not determined
            break;
        }
        case ALAuthorizationStatusRestricted: {
            // restricted
            break;
        }
        case ALAuthorizationStatusDenied: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR"
                                                            message:@"L’accès à vos photos est requis pour pouvoir les sélectionner. Merci d’aller dans l’app Réglages puis dans Confidentialité > Photos"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            break;
        }
        case ALAuthorizationStatusAuthorized: {
            
            break;
        }
        default: {
            break;
        }
    }
    
    
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch=[[event allTouches] anyObject];
    if([touch view] != self.nextBigView && [touch view] != self.bigTitle)
    {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
    
}
- (IBAction)addImgNo1:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Prendre une photo",
                            @"Parcourir les photos",
                            nil];
    
    [popup showInView: self.view];
    
    
    buttonClicked = 1;
}

- (IBAction)addImgNo2:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Prendre une photo",
                            @"Parcourir les photos",
                            nil];
    
    [popup showInView: self.view];
    
    buttonClicked = 2;
}

- (IBAction)addImgNo3:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Prendre une photo",
                            @"Parcourir les photos",
                            nil];
    
    [popup showInView: self.view];
    
    buttonClicked = 3;
}

- (IBAction)addImgNo4:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Prendre une photo",
                            @"Parcourir les photos",
                            nil];
    
    [popup showInView: self.view];
    
    buttonClicked = 4;
}


- (IBAction)addImgNo5:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Prendre une photo",
                            @"Parcourir les photos",
                            nil];
    
    [popup showInView: self.view];
    
    buttonClicked = 5;
}



- (IBAction)getBack:(id)sender {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {
            
            [self DeschidEcranulPentruPoza1];
        }
            break;
        case 1: {
            
            [self selectPhoto];
        }
            break;
        default:
            break;
    }
}
-(void)DeschidEcranulPentruPoza1{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}
- (void)selectPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    

    
   // NSLog(@"%.5f MBS",(float)[self testData:chosenImage].length/1024/1024);

    
    
    if(buttonClicked ==  1){
        self.imageNo1.image = chosenImage;
        [self.addImgNo1 setBackgroundImage:nil forState:UIControlStateNormal];
        [chosenImages setObject:chosenImage forKey:@"1"];

       // NSLog(@"%@", [NSByteCountFormatter stringFromByteCount:UIImageJPEGRepresentation(chosenImage, 1.0).length countStyle:NSByteCountFormatterCountStyleFile]);
        
        if((float)UIImageJPEGRepresentation(chosenImage, 1.0).length/1024/1024 > 1)
        {
            [self.imageNo1.layer setBorderColor:[UIColor redColor].CGColor];
            [self.imageNo1.layer setBorderWidth: 3.75 * self.view.frame.size.width / 375];
        }
        else {
            [self.imageNo1.layer setBorderColor:[self colorWithHexString:@"829B00"].CGColor];
            [self.imageNo1.layer setBorderWidth: 3.75 * self.view.frame.size.width / 375];
        }
        
    }
    else if(buttonClicked == 2){
        self.imageNo2.image = chosenImage;
        [self.addImgNo2 setBackgroundImage:nil forState:UIControlStateNormal];
        [chosenImages setObject:chosenImage forKey:@"2"];
        
        if((float)UIImageJPEGRepresentation(chosenImage, 1.0).length/1024/1024 > 1)
        {
            [self.imageNo2.layer setBorderColor:[UIColor redColor].CGColor];
            [self.imageNo2.layer setBorderWidth: 3.75 * self.view.frame.size.width / 375];
        }
        else {
            [self.imageNo2.layer setBorderColor:[self colorWithHexString:@"829B00"].CGColor];
            [self.imageNo2.layer setBorderWidth: 3.75 * self.view.frame.size.width / 375];
        }
        
    }
    else if(buttonClicked == 3){
        self.imageNo3.image = chosenImage;
        [self.addImgNo3 setBackgroundImage:nil forState:UIControlStateNormal];
        [chosenImages setObject:chosenImage forKey:@"3"];
         if((float)UIImageJPEGRepresentation(chosenImage, 1.0).length/1024/1024 > 1)
        {
            [self.imageNo3.layer setBorderColor:[UIColor redColor].CGColor];
            [self.imageNo3.layer setBorderWidth: 3.75 * self.view.frame.size.width / 375];
        }
        else {
            [self.imageNo3.layer setBorderColor:[self colorWithHexString:@"829B00"].CGColor];
            [self.imageNo3.layer setBorderWidth: 3.75 * self.view.frame.size.width / 375];
        }
    }
    else if(buttonClicked == 4){
        self.imageNo4.image = chosenImage;
        [self.addImgNo4 setBackgroundImage:nil forState:UIControlStateNormal];
       [chosenImages setObject:chosenImage forKey:@"4"];
        if((float)UIImageJPEGRepresentation(chosenImage, 1.0).length/1024/1024 > 1)
        {
            [self.imageNo4.layer setBorderColor:[UIColor redColor].CGColor];
            [self.imageNo4.layer setBorderWidth: 3.75 * self.view.frame.size.width / 375];
        }
        else {
            [self.imageNo4.layer setBorderColor:[self colorWithHexString:@"829B00"].CGColor];
            [self.imageNo4.layer setBorderWidth: 3.75 * self.view.frame.size.width / 375];
        }
    }
    else if(buttonClicked == 5){
        self.imageNo5.image = chosenImage;
        [chosenImages setObject:chosenImage forKey:@"5"];
         if((float)UIImageJPEGRepresentation(chosenImage, 1.0).length/1024/1024 > 1)
        {
            [self.imageNo5.layer setBorderColor:[UIColor redColor].CGColor];
            [self.imageNo5.layer setBorderWidth: 3.75 * self.view.frame.size.width / 375];
        }
        else {
            [self.imageNo5.layer setBorderColor:[self colorWithHexString:@"829B00"].CGColor];
            [self.imageNo5.layer setBorderWidth: 3.75 * self.view.frame.size.width / 375];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something1"]];
    
  //  NSLog(@"%@",chosenImages);
}
-(UIColor*)colorWithHexString:(NSString*)hex {
    
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (IBAction)finalCreateAnn:(id)sender {
    
//    self.finalCreateAnn.hidden = true;
//    
//    spinnerView = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.nextBigView.center.x - self.nextBigView.frame.origin.x - 18, self.finalCreateAnn.center.y - self.finalCreateAnn.frame.size.height/2, 35, 35)];
//    spinnerView.circleLayer.lineWidth = 3.0;
//    spinnerView.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
//    
//    [self.nextBigView addSubview:spinnerView];
//    [self.nextBigView bringSubviewToFront:spinnerView];
//    
//    [spinnerView beginRefreshing];
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        for(NSString *key in [chosenImages allKeys])
//        {
//            NSData *dataOfImage = UIImageJPEGRepresentation([chosenImages objectForKey:key], 1.0);
//            float imgData = dataOfImage.length;
//            if(imgData>1024*1024){
//                 NSLog(@"Old data: %.5f MBS",(float)UIImageJPEGRepresentation([chosenImages objectForKey:key], 1.0).length/1024/1024);
//                NSLog(@"New data: %.5f MBS",(float)[self testData:[chosenImages objectForKey:key]].length/1024/1024);
//            }
//            
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [spinnerView endRefreshing];
//             NSLog(@"POST ON SERVER");
//            
//        });
//        
//    });
    if([self isInternet] == YES){
  
    
    if([GlobalVariables getInstance].editerClicked == YES && [[GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer isEqualToString:@"editAnnClickedOnHomePage"]){

        [GlobalVariables getInstance].idOfAnnouncement = @"6521";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something"]];
        
    }
    else if([GlobalVariables getInstance].editerClicked == YES && [[GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer isEqualToString:@"EditAnnClickedOnSearchPage"] && [[GlobalVariables getInstance].currentAnnouncementScreen isEqualToString:@"AnnouncementsViewController"]){
        [GlobalVariables getInstance].idOfAnnouncement = @"6521";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something"]];
    }
    else if([GlobalVariables getInstance].editerClicked == YES && [[GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer isEqualToString:@"EditAnnClickedOnSearchPage"] && [[GlobalVariables getInstance].currentAnnouncementScreen isEqualToString:@"AnnouncementArticleView"]){
        
        [GlobalVariables getInstance].idOfAnnouncement = @"6521";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeSearch" object: [NSString stringWithFormat:@"closeSearch"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeScreen" object: [NSString stringWithFormat:@"Something"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something"]];
        
    }
    else if([GlobalVariables getInstance].editerClicked == YES && [[GlobalVariables getInstance].currentPopUpAnnouncementScreenForEditer isEqualToString:@"EditAnnClickedOnArtcilePage"]){
        
        [GlobalVariables getInstance].idOfAnnouncement = @"6521";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeScreen" object: [NSString stringWithFormat:@"Something"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openAnnouncement" object: [NSString stringWithFormat:@"Something"]];
    }
    else if([[GlobalVariables getInstance].currentPopUpAnnouncementScreen isEqualToString:@"AnnouncementSearchView"]){
        
        [self sendingAnHTTPPOSTRequestOnPostAnn:self.contactName withEmail:self.Email withTitle:self.title withDetails:self.Details];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
    
        
    }
    else if([[GlobalVariables getInstance].currentPopUpAnnouncementScreen isEqualToString:@"AnnouncementsViewController"] || [[GlobalVariables getInstance].currentPopUpAnnouncementScreen isEqualToString:@"AnnouncementArticleView"]){
        [self sendingAnHTTPPOSTRequestOnPostAnn:self.contactName withEmail:self.Email withTitle:self.title withDetails:self.Details];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
    
    }
    }
    
}
-(void)uploadMultiplePics
{
    NSString *string ;
    NSData *imageData;
    NSString*urlString=[NSString stringWithFormat:@"http://******"];
    // urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSMutableData *body;
    body = [NSMutableData data];
    for(NSString *key in [chosenImages allKeys]) // scrollViewImageArray is images count
    {
        double my_time = [[NSDate date] timeIntervalSince1970];
        int k=[key intValue]+1;
        NSString *imageName = [NSString stringWithFormat:@"%d%d",(int)key,(int)(my_time)];
        NSString *imagetag=[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image%d\"; filename=\"",k];
        string = [NSString stringWithFormat:@"%@%@%@", imagetag, imageName, @".jpg\"\r\n\""];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:string] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        UIImage *image=[[UIImage alloc]init];
        image=[chosenImages objectForKey:key];
        // scrollViewImageArray images array
        imageData = UIImageJPEGRepresentation(image, 90);
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [request setHTTPBody:body];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *s= [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
}
-(NSData *)testData:(UIImage *)imageToUpload
{
    NSData *dataOfImage = UIImageJPEGRepresentation(imageToUpload, 1.0);

    
    float compressionRate=1.0;
    
    float imgData = dataOfImage.length;
    
    
  //  NSLog(@"%@", [NSByteCountFormatter stringFromByteCount:dataOfImage.length countStyle:NSByteCountFormatterCountStyleFile]);
    
    while (imgData>1024*1024)
    {
        if (compressionRate>0.1)
        {
            compressionRate=compressionRate-0.05;
            dataOfImage = UIImageJPEGRepresentation(imageToUpload, compressionRate);
            imgData=dataOfImage.length;
        }
        else
        {
            return dataOfImage;
        }
    }
    return dataOfImage;
}
-(void)sendingAnHTTPPOSTRequestOnPostAnn: (NSString *)contact_name withEmail: (NSString *)email withTitle:(NSString *)title withDetails:(NSString *)details{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:adminAjax];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *params = [NSString stringWithFormat:@"action=dgab_add_petites_annonces&contact_name=%@&contact_email=%@&title=%@&details=%@",contact_name,email,title,details];
    
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
       // NSLog(@"%@",responseDict);
        
        if([[NSString stringWithFormat:@"%@",responseDict] isEqualToString:@"1"]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NOUS AVONS BIEN REÇU VOTRE ANNONCE !"
                                                        message:@"Vous devez vérifier l'adresse email du contact pour cette annonce. L'annonce restera désactivée tant que vous n'aurez pas fait la vérification. Un email de vérification vous a été envoyé.\n\nLes petites annonces doivent d'abord être approuvées par un administrateur du site, avant d'être visibles en ligne. Dès qu'un administrateur aura approuvé votre petite annonce, celle-ci sera visible en ligne. Merci pour votre patience !\n\nSi vous avez téléchargé des images, elles ne seront publiées qu'après leur validation par un administrateur."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR"
                                                            message:@"ERREUR"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];

        }
        
    }];
    [dataTask resume];
}
-(BOOL)isInternet{
    
    
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable))
    {
        
        return YES;
        
    }
    
    else {
        
        
        return NO;
    }
}
@end
