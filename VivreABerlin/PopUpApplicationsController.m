//
//  PopUpApplicationsController.m
//  VivreABerlin
//
//  Created by Stoica Mihail on 06/05/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "PopUpApplicationsController.h"
#import "Header.h"

@interface PopUpApplicationsController ()

@end

@implementation PopUpApplicationsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    self.popupviewApp.layer.cornerRadius = self.popupviewApp.frame.size.width/23;
    self.popupviewApp.clipsToBounds = true;
    
    self.closePopUp.image =[UIImage imageNamed:@"ClosePicture.png"];
    
    if ([AppName isEqualToString:@"Berlin"]) {
        
        self.firstArrow.image = [UIImage imageNamed:@"MunichArrow.png"];
        self.firstPicture.image = [UIImage imageNamed:@"MunichPictureApp.png"];
        
        self.secondArrow.image = [UIImage imageNamed:@"TokyoArrow"];
        self.secondPicture.image = [UIImage imageNamed:@"TokyoPictureApp.png"];
        
        self.thirdArrow.image = [UIImage imageNamed:@"athensArrow.png"];
        self.thirdPicture.image = [UIImage imageNamed:@"AthensPictureApp.png"];
        
        
        self.firstLabel.text = @"Munich";
        self.SecondLabel.text = @"Tokyo";
        self.thirdLabel.text = @"Athens";
        
        
    }
    else if ([AppName isEqualToString:@"Athens"]) {
        
        self.firstArrow.image = [UIImage imageNamed:@"MunichArrow.png"];
        self.firstPicture.image = [UIImage imageNamed:@"MunichPictureApp.png"];
        
        self.secondArrow.image = [UIImage imageNamed:@"TokyoArrow"];
        self.secondPicture.image = [UIImage imageNamed:@"TokyoPictureApp.png"];
        
        self.thirdArrow.image = [UIImage imageNamed:@"BerlinArrow.png"];
        self.thirdPicture.image = [UIImage imageNamed:@"BerlinPictureApp.png"];
        
        
        self.firstLabel.text = @"Munich";
        self.SecondLabel.text = @"Tokyo";
        self.thirdLabel.text = @"Berlin";
        
    }
    else if ([AppName isEqualToString:@"Munich"]) {
        
        self.firstArrow.image = [UIImage imageNamed:@"athensArrow.png"];
        self.firstPicture.image = [UIImage imageNamed:@"AthensictureApp.png"];
        
        self.secondArrow.image = [UIImage imageNamed:@"TokyoArrow"];
        self.secondPicture.image = [UIImage imageNamed:@"TokyoPictureApp.png"];
        
        self.thirdArrow.image = [UIImage imageNamed:@"BerlinArrow.png"];
        self.thirdPicture.image = [UIImage imageNamed:@"BerlinPictureApp.png"];
        
        
        self.firstLabel.text = @"Athens";
        self.SecondLabel.text = @"Tokyo";
        self.thirdLabel.text = @"Berlin";
        
    }
    else if ([AppName isEqualToString:@"Tokyo"]) {
        
        self.firstArrow.image = [UIImage imageNamed:@"athensArrow.png"];
        self.firstPicture.image = [UIImage imageNamed:@"AthensictureApp.png"];
        
        self.secondArrow.image = [UIImage imageNamed:@"MunichArrow"];
        self.secondPicture.image = [UIImage imageNamed:@"MunichPictureApp.png"];
        
        self.thirdArrow.image = [UIImage imageNamed:@"BerlinArrow.png"];
        self.thirdPicture.image = [UIImage imageNamed:@"BerlinPictureApp.png"];
        
        
        self.firstLabel.text = @"Athens";
        self.SecondLabel.text = @"Munich";
        self.thirdLabel.text = @"Berlin";
        
    }
    
    self.closePopUp.contentMode = UIViewContentModeScaleAspectFill;
    self.closePopUp.clipsToBounds = true;
    
    self.firstPicture.contentMode = UIViewContentModeScaleAspectFill;
    self.closePopUp.clipsToBounds = true;
    
    self.secondPicture.contentMode = UIViewContentModeScaleAspectFill;
    self.closePopUp.clipsToBounds = true;
    
    self.thirdPicture.contentMode = UIViewContentModeScaleAspectFill;
    self.closePopUp.clipsToBounds = true;
    
 //   self.firstArrow.contentMode = UIViewContentModeScaleAspectFill;
    self.closePopUp.clipsToBounds = true;
    
 //   self.secondArrow.contentMode = UIViewContentModeScaleAspectFill;
    self.closePopUp.clipsToBounds = true;
    
//    self.thirdArrow.contentMode = UIViewContentModeScaleAspectFill;
    self.closePopUp.clipsToBounds = true;
    
    self.firstLabel.adjustsFontSizeToFitWidth = true;
    self.SecondLabel.adjustsFontSizeToFitWidth = true;
    self.thirdLabel.adjustsFontSizeToFitWidth = true;
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch=[[event allTouches] anyObject];
    if([touch view] != self.popupviewApp)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"PopUpButtonClickedOnLeftController" object: [NSString stringWithFormat:@"closePopUp"]];
    
}
- (IBAction)closePopUpButton:(id)sender {
    
  // [[NSNotificationCenter defaultCenter] postNotificationName:@"PopUpButtonClickedOnLeftController" object: [NSString stringWithFormat:@"closePopUp"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
}
@end
