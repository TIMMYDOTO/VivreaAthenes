//
//  AddAnnouncementNextStep.h
//  VivreABerlin
//
//  Created by home on 19/08/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface AddAnnouncementNextStep : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *nextBigView;
@property (weak, nonatomic) IBOutlet UIView *bigTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageNo1;
@property (weak, nonatomic) IBOutlet UIImageView *imageNo2;
@property (weak, nonatomic) IBOutlet UIImageView *imageNo3;
@property (weak, nonatomic) IBOutlet UIImageView *imageNo4;
@property (weak, nonatomic) IBOutlet UIImageView *imageNo5;
@property (weak, nonatomic) IBOutlet UILabel *photoDesc;
- (IBAction)addImgNo1:(id)sender;
- (IBAction)addImgNo2:(id)sender;
- (IBAction)addImgNo3:(id)sender;
- (IBAction)addImgNo4:(id)sender;
- (IBAction)addImgNo5:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *addImgNo1;
@property (weak, nonatomic) IBOutlet UIButton *addImgNo2;
@property (weak, nonatomic) IBOutlet UIButton *addImgNo3;
@property (weak, nonatomic) IBOutlet UIButton *addImgNo4;
@property (weak, nonatomic) IBOutlet UIButton *addImgNo5;
@property (weak, nonatomic) IBOutlet UIButton *finalCreateAnn;

@property (weak, nonatomic) NSString *contactName;
@property (weak, nonatomic) NSString *Email;
@property (weak, nonatomic) NSString *title;
@property (weak, nonatomic) NSString *Details;


- (IBAction)finalCreateAnn:(id)sender;
- (IBAction)getBack:(id)sender;
@end
