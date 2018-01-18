//
//  AgendaArticlePopUp.m
//  VivreABerlin
//
//  Created by home on 30/07/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "AgendaArticlePopUp.h"
#import "GlobalVariables.h"
#import "UIImageView+Network.h"
#import "Header.h"

@interface AgendaArticlePopUp ()

@end

@implementation AgendaArticlePopUp

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    self.articleDate.adjustsFontSizeToFitWidth = true;
    self.articlePrix.adjustsFontSizeToFitWidth = true;
    self.articleCategory.adjustsFontSizeToFitWidth = true;
    self.articleHeure.adjustsFontSizeToFitWidth = true;
    self.articleTitle.adjustsFontSizeToFitWidth = true;
    self.endroidCategory.adjustsFontSizeToFitWidth = true;
    self.articleQuartier.adjustsFontSizeToFitWidth = true;
    self.webSitetitle.adjustsFontSizeToFitWidth = true;
    self.mapTitle.adjustsFontSizeToFitWidth = true;
    self.imageCaption.adjustsFontSizeToFitWidth = true;
    self.articleVideo.adjustsFontSizeToFitWidth = true;
    self.articleTitle.numberOfLines = 2;
    
    self.articleTitle.text = [NSString stringWithFormat:@"%@",[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"nom"]];
    self.imageCaption.text = [NSString stringWithFormat:@"%@",[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"caption"]];
    self.articleDate.text = [NSString stringWithFormat:@"%@",[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"date_formated"]];
    self.articleCategory.text = [NSString stringWithFormat:@"%@",[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"categorie"]];
    self.endroidCategory.text = [NSString stringWithFormat:@"%@",[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"endroit"]];
    self.articleQuartier.text = [NSString stringWithFormat:@"%@",[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"quartier"]];
    self.articlePrix.text = [NSString stringWithFormat:@"%@",[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"prix"]];
    self.articleHeure.text = [NSString stringWithFormat:@"%@",[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"heure"]];

    if(self.articleCategory.text.length == 0)
        self.articleCategory.text = @"---";
    if(self.articlePrix.text.length == 0)
        self.articlePrix.text = @"---";
    
    
    
  
    
    
    NSString* webName = [[NSString stringWithFormat:travelAgendaLink,[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"image"]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:webStringURL];
    
    
    [self.articleimage loadImageFromURL:url placeholderImage:nil cachingKey:[NSString stringWithFormat:@"%@",[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"nom"]]];
    
    self.articleimage.contentMode = UIViewContentModeScaleAspectFit;
    self.articleimage.clipsToBounds = true;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch=[[event allTouches] anyObject];
    if([touch view] != self.popUpview)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)articleWebsite:(id)sender {
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"site"]]]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"site"]]]];
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR"
                                                        message:@"Ce lien n'est pas encore fonctionnel"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
   }

- (IBAction)articleMap:(id)sender {
   // NSLog(@"%@",[NSString stringWithFormat:@"%@",[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"map"]]);
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"map"]]]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"map"]]]];
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR"
                                                        message:@"Ce lien n'est pas encore fonctionnel"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    

}
- (IBAction)closePopUp:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"closePopUp"]];
}
- (IBAction)articleVideoAction:(id)sender {
    
    
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"video"]]]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[GlobalVariables getInstance].agendaArticleInfo valueForKey:@"video"]]]];
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR"
                                                        message:@"Ce lien n'est pas encore fonctionnel"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}
@end
