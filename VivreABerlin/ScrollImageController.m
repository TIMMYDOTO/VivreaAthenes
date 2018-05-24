//
//  ScrollImageController.m
//  VivreABerlin
//
//  Created by home on 22/06/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "ScrollImageController.h"
#import "Header.h"
#import "GlobalVariables.h"
#import "UIImageView+Network.h"
#import "AppDelegate.h"
#import "SimpleFilesCache.h"

@interface ScrollImageController ()

@end

@implementation ScrollImageController
{
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    kAppDelegate.lockInPortrait = NO;
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:241/255.0f blue:245/255.0f alpha:1.0f];
    
    if([GlobalVariables getInstance].urlOfImageClicked != nil){
        
        NSString* webName = [[NSString stringWithFormat:@"%@", [GlobalVariables getInstance].urlOfImageClicked] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:webStringURL];
        
        
        [self.zoomingImage loadImageFromURL:url placeholderImage:[UIImage imageNamed:@"noimage.png"] cachingKey:[NSString stringWithFormat:@"%@Thumbnailllll",[GlobalVariables getInstance].idOfPost]];
        
        
        
        NSString *authorCaption = [[NSString alloc]init];
        authorCaption = [[NSUserDefaults standardUserDefaults]objectForKey:@"authorLblTxt"];
      
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[authorCaption dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        self.authorOfImage.attributedText = attrStr;
        [self.authorOfImage setTextColor:[UIColor whiteColor]];
        [self.authorOfImage setFont:[UIFont fontWithName:@"Montserrat-Light" size:16]];
        self.authorOfImage.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
       
        [GlobalVariables getInstance].zoomingImageClickedFromTagAgenda = NO;
        [GlobalVariables getInstance].urlOfImageClicked =  nil;
    }
    else if([GlobalVariables getInstance].urlOfImageClicked == nil){
        NSString *authorCaption = [[NSString alloc]init];
        authorCaption = [[NSUserDefaults standardUserDefaults]objectForKey:@"authorLblTxt"];
        
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[authorCaption dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        self.authorOfImage.attributedText = attrStr;
        [self.authorOfImage setTextColor:[UIColor whiteColor]];
        [self.authorOfImage setFont:[UIFont fontWithName:@"Montserrat-Light" size:16]];
        self.authorOfImage.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        [self.zoomingImage setImage:[SimpleFilesCache cachedImageWithName:@"imgHeader"]];
    }
    else if([GlobalVariables getInstance].announcementImageUrl != nil)
    {
       
        
        NSString* webName = [[NSString stringWithFormat:@"%@", [GlobalVariables getInstance].announcementImageUrl] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:webStringURL];
        [self.zoomingImage loadImageFromURL:url placeholderImage:[UIImage imageNamed:@"noimage.png"] cachingKey:[[[[NSString stringWithFormat:@"%@", [GlobalVariables getInstance].announcementImageUrl] substringFromIndex: [[NSString stringWithFormat:@"%@", [GlobalVariables getInstance].announcementImageUrl] length] - 20] stringByReplacingOccurrencesOfString:@"/" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""]];
        
        
        
        [GlobalVariables getInstance].zoomingImageClickedFromTagAgenda = NO;
        [GlobalVariables getInstance].announcementImageUrl = nil;
        
    }
    if([GlobalVariables getInstance].zoomingImageClickedFromTagAgenda){
        
        
        NSString* webName = [[NSString stringWithFormat:@"%@", [[[GlobalVariables getInstance].backGroundImageTag componentsSeparatedByString:@"lala"] objectAtIndex:0]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:webStringURL];
        
        
        [self.zoomingImage loadImageFromURL:url placeholderImage:[UIImage imageNamed:@"noimage.png"] cachingKey:[[[GlobalVariables getInstance].backGroundImageTag componentsSeparatedByString:@"lala"] objectAtIndex:1]];
        
          if([[[[GlobalVariables getInstance].backGroundImageTag componentsSeparatedByString:@"lala"] objectAtIndex:2] isEqualToString:@"123123"])
              self.authorOfImage.hidden = YES;
          else
              self.authorOfImage.text = [[[GlobalVariables getInstance].backGroundImageTag componentsSeparatedByString:@"lala"] objectAtIndex:2];
        
    }
    
    self.zoomingImage.contentMode = UIViewContentModeScaleAspectFit;
    self.zoomingImage.clipsToBounds = true;
    self.zoomingScroll.contentSize = self.zoomingImage.bounds.size;
    self.zoomingScroll.maximumZoomScale = 2.0;
    self.zoomingScroll.minimumZoomScale = 1.0;
    self.zoomingScroll.clipsToBounds = YES;
    self.zoomingScroll.delegate = self;
    self.zoomingScroll.zoomScale = .37;
    self.zoomingScroll.scrollsToTop = false;
    self.zoomingScroll.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    //tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
 
    self.authorOfImage.textColor = [UIColor whiteColor];
    [self.authorOfImage sizeToFit];
    self.authorOfImage.backgroundColor = [UIColor blackColor];
    self.authorOfImage.layer.cornerRadius = 2;
    self.authorOfImage.alpha = 0.2;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    [self.authorOfImage setFrame:CGRectMake(10, screenHeight/2+170, screenWidth -  20, 50)];
  
   // self.authorOfImage.adjustsFontSizeToFitWidth = true;
    
    
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    return true;
}
-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
}


-(UIView *) viewForZoomingInScrollView:(UIScrollView *)inScroll {
    return self.zoomingImage;
}
- (NSString *)stringByStrippingHTML:(NSString *)inputString
{
    NSMutableString *outString;
    
    if (inputString)
    {
        outString = [[NSMutableString alloc] initWithString:inputString];
        
        if ([inputString length] > 0)
        {
            NSRange r;
            
            while ((r = [outString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            {
                [outString deleteCharactersInRange:r];
            }
        }
    }
    
    return outString;
}

- (NSString *)stringByDecodingXMLEntities:(NSString *)text {
    NSUInteger myLength = [text length];
    NSUInteger ampIndex = [text rangeOfString:@"&" options:NSLiteralSearch].location;
    
    if (ampIndex == NSNotFound) {
        return text;
    }
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    
    
    NSScanner *scanner = [NSScanner scannerWithString:text];
    
    [scanner setCharactersToBeSkipped:nil];
    
    NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
    
    do {
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
            
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
            
            if (gotNumber) {
                [result appendFormat:@"%C", (unichar)charCode];
                
                [scanner scanString:@";" intoString:NULL];
            }
            else {
                NSString *unknownEntity = @"";
                
                [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
                
                
                [result appendFormat:@"&#%@%@", xForHex, unknownEntity];
                
                NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
            }
        }
        else {
            NSString *amp;
            [scanner scanString:@"&" intoString:&amp];  //an isolated & symbol
            [result appendString:amp];
        }
    }
    while (![scanner isAtEnd]);
    
finish:
    return result;
}

@end
