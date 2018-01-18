//
//  AgendaViewController.m
//  VivreABerlin
//
//  Created by home on 25/04/17.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "AgendaViewController.h"
#import "Header.h"
#import "GlobalVariables.h"
#import "AgendaCell.h"
#import "UIImageView+Network.h"
#import "JTMaterialSpinner.h"
#import "SimpleFilesCache.h"
#import "Reachability.h"
#import "CatsSubCatsCell.h"
#import "OLGhostAlertView.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface AgendaViewController ()

@end

@implementation AgendaViewController
{
    BOOL changeFrameOnce;
    CGFloat searchfieldOriginY;
    NSMutableArray *agendaInfosArray;
    NSMutableArray *articleId;
    BOOL isFiltred;
    JTMaterialSpinner *spinnerview;
    
    NSMutableArray *dossiersTitles;
    NSMutableArray *dossiersBgs;
    NSMutableArray *dossiersContents;
    NSMutableArray *dossersBgsIds;
    NSMutableArray *allTagsName;
    NSMutableArray *allSlugsName;
    NSMutableArray *dossiersAuthors;
    
    NSMutableArray *arrayUsedInTable;
    CGRect dossierHeaderFrame;
    
    BOOL displayAgendaPost;
    BOOL mustDisplayAgendaPost;
    NSMutableDictionary *Dictionary;
    NSMutableDictionary *INFOSDICT;
    NSString *agendaTAG;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.reloadScreen.hidden = true;
    arrayUsedInTable = [[NSMutableArray alloc] init];
    displayAgendaPost = false;
    mustDisplayAgendaPost = false;
    self.agendaPostsTableView.hidden = true;
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserBoughtTheMap"] isEqualToString:@"YES"])
        self.offlineButton.hidden = YES;
    self.searchField.userInteractionEnabled = false;
    changeFrameOnce = true;
    self.agendaPreviewContent.delegate = self;
    
    self.searchfieldView.frame = CGRectMake(self.searchfieldView.frame.origin.x, self.viewWithTitles.frame.origin.y - self.searchfieldView.frame.size.height - (self.agendaTable.frame.origin.y - self.viewWithTitles.frame.origin.y - self.viewWithTitles.frame.size.height + 2) * 2, self.searchfieldView.frame.size.width, self.searchfieldView.frame.size.height);
    self.noArticle.hidden = true;
    self.noArticle.delegate = self;
    self.nosDossires.hidden = YES;
    
    self.dossiersHeaderView.hidden = YES;
    dossierHeaderFrame = self.dossiersHeaderView.frame;
    self.dossiersHeaderView.layer.cornerRadius = 8;
    self.dossiersHeaderView.clipsToBounds = true;
    spinnerview = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.center.x - 22, self.view.center.y - 22, 45, 45)];
    spinnerview.circleLayer.lineWidth = 3.0;
    spinnerview.circleLayer.strokeColor = [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f].CGColor;
    
    [self.view addSubview:spinnerview];
    [self.view bringSubviewToFront:spinnerview];
    
    self.agendaScrollView.delaysContentTouches = false;
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:241/255.0f blue:245/255.0f alpha:1.0f];
    self.logo.image = [UIImage imageNamed:@"Logo.png"];
    self.logo.contentMode = UIViewContentModeScaleAspectFit;
    self.logo.clipsToBounds = true;
    self.rainbow.contentMode = UIViewContentModeScaleAspectFit;
    self.rainbow.clipsToBounds = true;
    [self.agendaScrollView bringSubviewToFront:self.rainbow];
    [self.agendaScrollView bringSubviewToFront:self.logo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Spin)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self Spin];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    
    
    if(hour >= 20){
        self.changeableBg.image =[UIImage imageNamed:@"BackgroundNight.png"];
        if (self.changeableBg.image == nil){
            self.changeableBg.image = [UIImage imageNamed:@"BackgroundDay.png"];
        }
    }
    else {
        self.changeableBg.image = [UIImage imageNamed:@"BackgroundDay.png"];
        if (self.changeableBg.image == nil){
            self.changeableBg.image = [UIImage imageNamed:@"BackgroundNight.png"];
        }
    }
    
    
    self.dossiersView.backgroundColor = self.view.backgroundColor;
    self.changeableBg.clipsToBounds = true;
    self.changeableBg.contentMode = UIViewContentModeScaleAspectFill;
    
    
    self.titleOfContent.text = [NSString stringWithFormat:@"Agenda de %@",AppName];
    self.titleOfContent.adjustsFontSizeToFitWidth = true;
    
    self.passage.text = [NSString stringWithFormat:@"%@ > Agenda",[GlobalVariables getInstance].comingFromForAgenda];
    self.passage.adjustsFontSizeToFitWidth = true;
    
    
    self.searchfieldView.layer.cornerRadius = 5;
    [self.searchfieldView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [self.searchfieldView.layer setBorderWidth: 0.5];
    
    
    self.agendaContentView.layer.cornerRadius = 5;
    [self.agendaContentView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [self.agendaContentView.layer setBorderWidth: 0.2];
    
    self.agendaScrollView.delaysContentTouches = NO;
    
    NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"AgendaArray"]]];
    agendaInfosArray = [[NSMutableArray alloc] init];
    if(dictionary.count != 0)
        for(int i = 0; i< [[dictionary valueForKey:@"events"] count];i++)
            [agendaInfosArray addObject:[dictionary valueForKey:@"events"][i]];
    
    if([self isInternet ] == YES){
        
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"canMakeRequestForAgenda"];
        
        
        // NSLog(@"AGEnda cu request");
        
        //   NSLog(@"%f",self.agendaPreviewContent.frame.size.height);
        
        
        [spinnerview beginRefreshing];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self sendingAnHTTGETTRequestAgenda:agendaLink];
            
            dossiersTitles = [[NSMutableArray alloc]init];
            dossiersBgs = [[NSMutableArray alloc]init];
            dossiersContents = [[NSMutableArray alloc]init];
            dossersBgsIds = [[NSMutableArray alloc]init];
            allSlugsName = [[NSMutableArray alloc]init];
            allTagsName = [[NSMutableArray alloc]init];
             dossiersAuthors = [[NSMutableArray alloc]init];
            NSDictionary *restult= [self makingRequestForDossiers:dossierLink];
            
 
            
            for(int i = 0 ; i < restult.count; i++){
                
                NSLog(@"contor : %d", i);
                [dossiersTitles addObject:[restult valueForKey:@"name"][i]];
                [dossiersContents addObject:[restult valueForKey:@"description"][i]];
                 [allSlugsName addObject:[restult valueForKey:@"slug"][i]];
                 [allTagsName addObject:[restult valueForKey:@"name"][i]];
                if([NSString stringWithFormat:@"%@",[restult valueForKey:@"background_image"][i]].length > 5){
                [dossiersBgs addObject:[[restult valueForKey:@"background_image"][i] valueForKey:@"url"]];
                [dossersBgsIds addObject:[[restult valueForKey:@"background_image"][i] valueForKey:@"id"]];
                [dossiersAuthors addObject:[self stringByDecodingXMLEntities:[self stringByStrippingHTML:[[restult valueForKey:@"background_image"][i] valueForKey:@"credits"]]]];
                }
                else{
                    [dossiersBgs addObject:@"32"];
                    [dossersBgsIds addObject:@"122"];
                    [dossiersAuthors addObject:@"123123"];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                
                
                // [UIView transitionWithView:self.agendaPreviewContent
                //                   duration:0.4f
                //     options:UIViewAnimationOptionTransitionCrossDissolve
                //    animations:^{
                
                NSMutableDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"AgendaArray"]];
                
                self.agendaPreviewContent.text = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"page_description"]];
                
                
                
                self.agendaPreviewContent.textColor = [UIColor darkGrayColor];
                self.agendaPreviewContent.font = [UIFont fontWithName:@"Montserrat-Light" size:16];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    self.agendaPreviewContent.font = [UIFont fontWithName:@"Montserrat-Light" size:19];
                self.agendaPreviewContent.scrollEnabled = false;
                self.agendaPreviewContent.editable = false;
                
                [self.agendaPreviewContent sizeToFit];
                
                
                // } completion:nil];
                
                
                
                
                //       NSLog(@"%f",self.agendaPreviewContent.frame.size.height);
                
                [self.agendaTable reloadData];
                
              
                
                self.searchfieldView.frame = CGRectMake(self.searchfieldView.frame.origin.x, self.agendaPreviewContent.frame.origin.y + self.agendaPreviewContent.frame.size.height + self.logo.frame.size.height/5, self.searchfieldView.frame.size.width, self.searchfieldView.frame.size.height);
                
                
                self.viewWithTitles.frame = CGRectMake(self.viewWithTitles.frame.origin.x, self.searchfieldView.frame.origin.y +  self.searchfieldView.frame.size.height + self.logo.frame.size.height/4, self.viewWithTitles.frame.size.width, self.viewWithTitles.frame.size.height);
                
                
                CGRect frame = self.agendaTable.frame;
                frame.origin.y = self.viewWithTitles.frame.origin.y + self.viewWithTitles.frame.size.height + self.logo.frame.size.height/10;
                frame.size.height = self.agendaTable.contentSize.height;
                self.agendaTable.frame = frame;
                
                
                self.agendaContentView.frame = CGRectMake(self.agendaContentView.frame.origin.x, self.viewWithTitles.frame.origin.y - 3, self.agendaContentView.frame.size.width, self.viewWithTitles.frame.size.height + self.agendaTable.frame.size.height + self.logo.frame.size.height/4);
                
                searchfieldOriginY = self.viewWithTitles.frame.origin.y - self.searchfieldView.frame.size.height - (self.agendaTable.frame.origin.y - self.viewWithTitles.frame.origin.y - self.viewWithTitles.frame.size.height + 2) * 2 ;
                
                self.agendaScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.agendaContentView.frame.origin.y + self.agendaContentView.frame.size.height + self.logo.frame.size.height/2.5);
                
                
                if(agendaInfosArray.count != 0)
                    self.searchField.userInteractionEnabled = true;
                
            //    if(agendaInfosArray.count == 0){
                    self.noArticle.hidden = false;
                    self.noArticle.frame = CGRectMake(self.noArticle.frame.origin.x, self.viewWithTitles.frame.size.height + self.viewWithTitles.frame.origin.y + self.logo.frame.size.height / 3 , self.noArticle.frame.size.width, self.noArticle.frame.size.height);
                    NSMutableAttributedString * strr = [[NSMutableAttributedString alloc] initWithString:@"Aucun évènement prévu. Suggérez-nous en un"];
                    [strr addAttribute: NSLinkAttributeName value: @"OpenEMail" range: NSMakeRange(strr.length-19, 19)];
                    self.noArticle.attributedText = strr;
                    self.noArticle.scrollEnabled =false;
                    self.noArticle.editable = false;
                    self.noArticle.textColor = self.agendaPreviewContent.textColor;
                    self.noArticle.font = [UIFont fontWithName:@"Montserrat-Regular" size:self.agendaPreviewContent.font.pointSize ];
                    [self.noArticle sizeToFit];
                    
                    // self.agendaScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.agendaContentView.frame.origin.y + self.agendaContentView.frame.size.height + self.noArticle.frame.size.height * 1.1);
                    
                    [self.dossiersTable reloadData];
                    
                    
                    CGRect newHeight1 = self.dossiersView.frame;
                    newHeight1.size.height = self.dossiersTable.frame.origin.y + self.dossiersTable.rowHeight * [dossiersTitles count];
                    self.dossiersView.frame = newHeight1;
                    
                    CGRect newHeight = self.dossiersTable.frame;
                    newHeight.origin.y = self.logo.frame.size.height *1.5;
                    newHeight.size.height = self.dossiersTable.rowHeight * [dossiersTitles count];
                    self.dossiersTable.frame = newHeight;
                    
                    CGRect newOrigin = self.nosDossires.frame;
                    newOrigin.origin.y = self.logo.frame.size.height * 0.8;
                    newOrigin.size.height = dossierHeaderFrame.size.height;
                    self.nosDossires.frame = newOrigin;
                    
                    
                  //  [UIView animateWithDuration:0.1
                       //              animations:^{
                                         self.dossiersHeaderView.frame = dossierHeaderFrame;
                                         self.closeDossiersView.frame = dossierHeaderFrame;
                         //            }
                         //            completion:nil];
                    
                    
                    self.dossiersTable.backgroundColor = [UIColor clearColor];
                    
                    self.searchfieldView.hidden = YES;
                    
                    if([self isInternet]){
                    self.dossiersHeaderView.hidden = NO;
                        self.dossiersView.hidden = NO;
                    self.nosDossires.hidden = NO;
                    }
                    else{
                        self.dossiersHeaderView.hidden = YES;
                        self.dossiersView.hidden = YES;
                        self.nosDossires.hidden = YES;
                        self.searchfieldView.hidden = NO;
                    }
                    
                    self.agendaScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.dossiersView.frame.origin.y + self.dossiersTable.frame.size.height + self.noArticle.frame.size.height * 0.5 + self.dossiersHeaderView.frame.size.height *2.5);
                    
                    
                    
                    if([[INFOSDICT valueForKey:@"agenda_posts"] intValue] == 1) {
                        displayAgendaPost = true;
                        agendaTAG = [INFOSDICT objectForKey:@"agenda_category"];
                    }
                    else {
                        displayAgendaPost = false;
                        agendaTAG = [INFOSDICT objectForKey:@"agenda_category"];
                    }
                    
                    
               // }
              //  else{
             //       self.noArticle.hidden = true;
            //    }
                
                
                [spinnerview endRefreshing];
            });
        });
    }
    else{
        //   NSLog(@"AGEnda fara request");
        
        self.dossiersView.hidden = YES;
        self.dossiersHeaderView.hidden = YES;
        
        [spinnerview beginRefreshing];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView transitionWithView:self.agendaPreviewContent
                              duration:0.4f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                
                                
                                self.agendaPreviewContent.text = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"page_description"]];
                                
                                
                                self.agendaPreviewContent.textColor = [UIColor darkGrayColor];
                                self.agendaPreviewContent.font = [UIFont fontWithName:@"Montserrat-Light" size:16];
                                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                                    self.agendaPreviewContent.font = [UIFont fontWithName:@"Montserrat-Light" size:19];
                                self.agendaPreviewContent.scrollEnabled = false;
                                self.agendaPreviewContent.editable = false;
                                [self.agendaPreviewContent sizeToFit];
                                
                                
                            } completion:nil];
            
            
            self.searchfieldView.frame = CGRectMake(self.searchfieldView.frame.origin.x, self.agendaPreviewContent.frame.origin.y +  self.agendaPreviewContent.frame.size.height + self.logo.frame.size.height/5, self.searchfieldView.frame.size.width, self.searchfieldView.frame.size.height);
            
            self.viewWithTitles.frame = CGRectMake(self.viewWithTitles.frame.origin.x, self.searchfieldView.frame.origin.y +  self.searchfieldView.frame.size.height + self.logo.frame.size.height/4, self.viewWithTitles.frame.size.width, self.viewWithTitles.frame.size.height);
            
            CGRect frame = self.agendaTable.frame;
            frame.origin.y = self.viewWithTitles.frame.origin.y + self.viewWithTitles.frame.size.height + self.logo.frame.size.height/10;
            frame.size.height = self.agendaTable.contentSize.height;
            self.agendaTable.frame = frame;
            
            
            
            self.agendaContentView.frame = CGRectMake(self.agendaContentView.frame.origin.x, self.viewWithTitles.frame.origin.y - 3, self.agendaContentView.frame.size.width, self.viewWithTitles.frame.size.height + self.agendaTable.frame.size.height + self.logo.frame.size.height/4);
            
            searchfieldOriginY = self.viewWithTitles.frame.origin.y - self.searchfieldView.frame.size.height - (self.agendaTable.frame.origin.y - self.viewWithTitles.frame.origin.y - self.viewWithTitles.frame.size.height + 2) * 2 ;
            
            self.agendaScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.agendaContentView.frame.origin.y + self.agendaContentView.frame.size.height + self.logo.frame.size.height/2.5);
            
            
            if(agendaInfosArray.count != 0)
                self.searchField.userInteractionEnabled = true;
            
            if(agendaInfosArray.count == 0){
                self.noArticle.hidden = false;
                self.noArticle.frame = CGRectMake(self.noArticle.frame.origin.x, self.viewWithTitles.frame.size.height + self.viewWithTitles.frame.origin.y + 10 , self.noArticle.frame.size.width, self.noArticle.frame.size.height);
                NSMutableAttributedString * strr = [[NSMutableAttributedString alloc] initWithString:@"Aucun évènement prévu. Suggérez-nous en un"];
                [strr addAttribute: NSLinkAttributeName value: @"OpenEMail" range: NSMakeRange(strr.length-19, 19)];
                self.noArticle.attributedText = strr;
                self.noArticle.scrollEnabled =false;
                self.noArticle.editable = false;
                self.noArticle.textColor = self.agendaPreviewContent.textColor;
                self.noArticle.font = [UIFont fontWithName:@"Montserrat-Regular" size:self.agendaPreviewContent.font.pointSize];
                [self.noArticle sizeToFit];
                
                self.agendaScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.agendaContentView.frame.origin.y + self.agendaContentView.frame.size.height + self.noArticle.frame.size.height * 1.1);
                
                if([[INFOSDICT valueForKey:@"agenda_posts"] intValue] == 1)
                    displayAgendaPost = true;
                else
                    displayAgendaPost = false;
                
                
                
               // dispatch_async(dispatch_get_main_queue(), ^{
                //    [self showMessage:@"aucun événement à venir!"];
                    
                    self.dossiersTable.frame = CGRectMake(self.dossiersTable.frame.origin.x, self.dossiersHeaderView.frame.origin.y, self.dossiersTable.frame.size.width, self.dossiersTable.frame.size.height);
                    self.dossiersHeaderView.hidden = true;
                    self.closeDossiersView.hidden = true;
                    self.agendaScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.dossiersView.frame.origin.y + self.dossiersTable.frame.size.height + self.noArticle.frame.size.height * 0.5);
                    [spinnerview endRefreshing];
                    self.nosDossires.hidden = true;
                    self.slugLabel.text = @"Nos dossiers";
               // });
           // }
            }
            else{
                self.noArticle.hidden = true;
            }
            
            [spinnerview endRefreshing];
            
            
        });
        
        
        
    }
    
    
    
    
    self.agendaTable.scrollEnabled = false;
    self.agendaScrollView.bounces = true;
    self.agendaTable.bounces = false;
    self.searchField.delegate = self;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:
     UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [tap setCancelsTouchesInView:NO];
    
    
    
    [self.searchField addTarget:self
                         action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
    
    
    
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self Spin];
}
-(void)textFieldDidChange :(UITextField *)theTextField{
    
    [self.agendaScrollView setContentOffset:CGPointMake(0, searchfieldOriginY + 1) animated:YES];
    
    if ([theTextField.text length] == 0) {
        isFiltred = FALSE;
        
    }
    
    else
    {
        
        isFiltred = TRUE;
        
        articleId = [[NSMutableArray alloc] init];
        
        
        for (int p=0; p<agendaInfosArray.count; p++)
            if ([[NSString stringWithFormat:@"%@",[agendaInfosArray valueForKey:@"nom"][p]] rangeOfString:theTextField.text options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [articleId addObject:[NSString stringWithFormat:@"%@",[agendaInfosArray valueForKey:@"nom"][p]]];
                //      NSLog(@"%@",[NSString stringWithFormat:@"%@",[agendaInfosArray valueForKey:@"nom"][p]]);
            }
        
        
    }
    
    [self.agendaTable reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //This code will run in the main thread:
        
        CGRect frame = self.agendaTable.frame;
        frame.size.height = self.agendaTable.contentSize.height;
        self.agendaTable.frame = frame;
        
        
        self.agendaContentView.frame = CGRectMake(self.agendaContentView.frame.origin.x, self.agendaContentView.frame.origin.y, self.agendaContentView.frame.size.width, self.viewWithTitles.frame.size.height + self.agendaTable.frame.size.height + self.logo.frame.size.height/4);
        
        // self.agendaScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.agendaContentView.frame.origin.y + self.agendaContentView.frame.size.height );
        
    });
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(changeFrameOnce == true && self.agendaScrollView.contentOffset.y >=  (self.viewWithTitles.frame.origin.y - self.searchfieldView.frame.size.height - (self.agendaTable.frame.origin.y - self.viewWithTitles.frame.origin.y - self.viewWithTitles.frame.size.height + 2) * 2)){
        
        
        [self.searchfieldView.layer setBorderColor: [[UIColor blueColor] CGColor]];
        [self.searchfieldView.layer setBorderWidth: 0.5];
        
        [self.view addSubview:self.searchfieldView];
        [self.view bringSubviewToFront:self.searchfieldView];
        
        self.searchfieldView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.searchfieldView.frame.size.height);
        changeFrameOnce = false;
        
        
        
        
        
    }
    else if(changeFrameOnce == false && self.agendaScrollView.contentOffset.y <= searchfieldOriginY - 1){
        
        
        
        
        
        [self.agendaScrollView addSubview:self.searchfieldView];
        [self.agendaScrollView bringSubviewToFront:self.searchfieldView];
        
        
        self.searchfieldView.frame = CGRectMake(self.agendaTable.frame.origin.x, self.viewWithTitles.frame.origin.y - self.searchfieldView.frame.size.height - (self.agendaTable.frame.origin.y - self.viewWithTitles.frame.origin.y - self.viewWithTitles.frame.size.height + 2) * 2, self.agendaTable.frame.size.width, self.searchfieldView.frame.size.height);
        changeFrameOnce = true;
        
        [self.searchfieldView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
        [self.searchfieldView.layer setBorderWidth: 0.5];
        
        
        
        
        
        
        
    }
    
    if (scrollView.contentOffset.y < 0) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    //    if([self.searchField isFirstResponder] == YES && self.agendaScrollView.contentOffset.y < self.searchfieldView.frame.origin.y - 10)
    //       [self.searchField resignFirstResponder];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.dossiersTable){
        if([self isInternet])
            return dossiersTitles.count;
        else return 0;
    }
    else{
        if (tableView == self.agendaPostsTableView){
            return arrayUsedInTable.count;
        }
        else {
        if(isFiltred == FALSE){
            //        if(agendaInfosArray.count == 0)
            //        self.noArticle.hidden = NO;
            // else self.noArticle.hidden = YES;
            
            return agendaInfosArray.count;
        }
        else{
            //if(articleId.count == 0)
            //self.noArticle.hidden = NO;
            //else self.noArticle.hidden = YES;
            
            return articleId.count;
        }
            
        }
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AgendaCell";
    
    AgendaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(tableView == self.agendaPostsTableView) {
        
        static NSString *CellIdentifier = @"CatsSubCatsCell";
        
        CatsSubCatsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [cell.articleImage loadImageFromURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrayUsedInTable valueForKey:@"thumbnail_url"][indexPath.row]]] placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@",[arrayUsedInTable valueForKey:@"id"][indexPath.row]]];
        
        
        
        cell.articleContent.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[arrayUsedInTable valueForKey:@"excerpt"][indexPath.row]]];
        
        cell.articleTitle.text = [arrayUsedInTable valueForKey:@"title"][indexPath.row];
        cell.articleTitle.font = [UIFont fontWithName:cell.articleTitle.font.fontName size:cell.articleTitle.font.pointSize + 2];
        
        cell.articleContent.text = [cell.articleContent.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        if(!cell.articleContent.text.length)
            cell.articleContent.text = @"-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
        
        cell.backgroundColor = [UIColor clearColor];
        cell.articleContent.text = [[cell.articleContent.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        
        
        if (indexPath.row == arrayUsedInTable.count - 1){
            [cell.separatorView setHidden:YES];
            [cell.didSelectImage setHidden:YES];
            
        }
        
        return cell;
        
    }
    
    else if(tableView == self.agendaTable){
        if(isFiltred == FALSE){
            
            cell.elementNom.text = [NSString stringWithFormat:@"%@",[agendaInfosArray valueForKey:@"nom"][indexPath.row]];
            
            NSString* webName = [[NSString stringWithFormat:travelAgendaLink,[agendaInfosArray valueForKey:@"image"][indexPath.row]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL* url = [NSURL URLWithString:webStringURL];
            
            [cell.elementImage loadImageFromURL:url placeholderImage:nil cachingKey:[NSString stringWithFormat:@"%@",[agendaInfosArray valueForKey:@"nom"][indexPath.row]]];
            cell.elementAuthor.text = [NSString stringWithFormat:@"%@",[agendaInfosArray valueForKey:@"caption"][indexPath.row]];
            cell.elementDate.text = [NSString stringWithFormat:@"%@",[agendaInfosArray valueForKey:@"date_formated"][indexPath.row]];
            
            
            
            return cell;
        }
        else{
            
            for(int i = 0; i< agendaInfosArray.count ; i++){
                if([[NSString stringWithFormat:@"%@",[agendaInfosArray valueForKey:@"nom"][i]] isEqualToString:articleId[indexPath.row]]){
                    cell.elementNom.text = [NSString stringWithFormat:@"%@",[agendaInfosArray valueForKey:@"nom"][i]];
                    cell.elementDate.text = [NSString stringWithFormat:@"%@",[agendaInfosArray valueForKey:@"date"][i]];
                    
                    NSString* webName = [[NSString stringWithFormat:travelAgendaLink,[agendaInfosArray valueForKey:@"image"][i]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSString* webStringURL = [webName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL* url = [NSURL URLWithString:webStringURL];
                    
                    [cell.elementImage loadImageFromURL:url placeholderImage:nil cachingKey:[NSString stringWithFormat:@"%@",[agendaInfosArray valueForKey:@"nom"][i]]];
                    cell.elementAuthor.text = [NSString stringWithFormat:@"%@",[agendaInfosArray valueForKey:@"caption"][i]];
                    cell.elementDate.text = [NSString stringWithFormat:@"%@",[agendaInfosArray valueForKey:@"date_formated"][i]];
                    
                    
                }
                
                
                
            }
            
            
            return cell;
            
        }
    }
    else {
        static NSString *CellIdentifier = @"CatsSubCatsCell";
        
        CatsSubCatsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
         [cell.articleImage loadImageFromURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",dossiersBgs[indexPath.row]]] placeholderImage: [UIImage imageNamed:@"PlaceHolderImage.png"] cachingKey:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",dossersBgsIds[indexPath.row]]]];
        
        
        
        cell.articleContent.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:dossiersContents[indexPath.row]]];
        
        cell.articleTitle.text = dossiersTitles[indexPath.row];
        cell.articleTitle.font = [UIFont fontWithName:cell.articleTitle.font.fontName size:cell.articleTitle.font.pointSize + 2];
        
        cell.articleContent.text = [cell.articleContent.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        if(!cell.articleContent.text.length)
            cell.articleContent.text = @"----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------";
    
        cell.backgroundColor = [UIColor clearColor];
        cell.articleContent.text = [[cell.articleContent.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        
        
        if (indexPath.row == dossiersTitles.count - 1){
            [cell.separatorView setHidden:YES];
            [cell.didSelectImage setHidden:YES];
            
        }
        return cell;
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //  [self.searchField resignFirstResponder];
    
    if(tableView == self.agendaPostsTableView) {
        
        [GlobalVariables getInstance].idOfPost =[arrayUsedInTable[indexPath.row] valueForKey:@"id"];
        [GlobalVariables getInstance].comingFromViewController = @"AgendaViewController";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
        
    }
    else if(tableView == self.agendaTable){
        if(isFiltred == false) {
            //  NSLog(@"%ld",(long)indexPath.row);
            
            [GlobalVariables getInstance].agendaArticleInfo = agendaInfosArray[indexPath.row];
            
        }
        else {
            //  NSLog(@"%ld",(long)indexPath.row);
            for(int i = 0; i< agendaInfosArray.count ; i++){
                if([[NSString stringWithFormat:@"%@",[agendaInfosArray valueForKey:@"nom"][i]] isEqualToString:articleId[indexPath.row]]){
                    [GlobalVariables getInstance].agendaArticleInfo = agendaInfosArray[i];
                }
                
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"AgendaArticlePopUp"]];
    }
    else{
        [GlobalVariables getInstance].backToPostHasToBeHidden =  YES;
        [GlobalVariables getInstance].slugName = allTagsName[indexPath.row];
        [GlobalVariables getInstance].backGroundImageTag = [NSString stringWithFormat:@"%@lala%@lala%@",dossiersBgs[indexPath.row],dossersBgsIds[indexPath.row],dossiersAuthors[indexPath.row]];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ComingFromPostTag"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",allSlugsName[indexPath.row]] forKey:@"ComingFromAgendaTag"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"CatsSubCatsController"]];
    
    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(changeFrameOnce == true)
        [self.agendaScrollView setContentOffset:CGPointMake(0, searchfieldOriginY+1) animated:YES];
}
-(void)Spin{
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 10.0f;
    animation.repeatCount = INFINITY;
    [self.rainbow.layer addAnimation:animation forKey:@"SpinAnimation"];
    
}
-(void)dismissKeyboard
{
    [self.searchField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
-(void)keyboardWillHide{
    dispatch_async(dispatch_get_main_queue(), ^{
        //This code will run in the main thread:
        self.agendaScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.agendaContentView.frame.origin.y + self.agendaContentView.frame.size.height + self.logo.frame.size.height/2.5);
        
    });
    
}

- (IBAction)openSideMenu:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"menuButton"]];
}

-(void)sendingAnHTTGETTRequestAgenda: (NSString *)url{
    
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
    
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    
    
    INFOSDICT = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
    agendaInfosArray = [[NSMutableArray alloc]init];
    
    
    
    for(int i = 0; i< [[INFOSDICT valueForKey:@"events"] count];i++)
        [agendaInfosArray addObject:[INFOSDICT valueForKey:@"events"][i]];
    
    if([self isInternet] == YES)
        [SimpleFilesCache saveToCacheDirectory:[NSKeyedArchiver archivedDataWithRootObject: INFOSDICT]
                                      withName:@"AgendaArray"];
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
- (IBAction)openiAPController:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"IAPViewController"]];
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([[URL absoluteString] isEqualToString:@"OpenEMail"]) {
        
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
            
            [mailCont setSubject:@"Suggestion Agenda"];
            [mailCont setToRecipients:[NSArray arrayWithObject:@"myFriends@email.com"]];
            [mailCont setMessageBody:@"BLABLABLABLA" isHTML:NO];
            
            [self presentViewController:mailCont animated:YES completion:nil];
        }
        
        return NO;
    }
    return YES;
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(NSDictionary *)makingRequestForDossiers:(NSString *)url
{
    
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
    
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
}
- (IBAction)closeDossiers:(id)sender {
    
    if (displayAgendaPost) {
        
        
        [spinnerview beginRefreshing];
        
      
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            
            [self sendingAnHTTGETTRequestCategoryClicked:[NSString stringWithFormat:categoryLink,agendaTAG,@"0"]];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[Dictionary valueForKey:@"results"] isKindOfClass:[NSArray class]]) {
                [self.dossiersView removeFromSuperview];
                self.slugLabel.text = @"Événements";
                
                    mustDisplayAgendaPost = true;
                    self.agendaPostsTableView.hidden = false;
                    
                    self.agendaTable.bounces = false;
                    //   self.ticketTable.scrollEnabled = false;
                    self.reloadScreen.hidden = false;
                
                for(int i = 0 ; i < [[Dictionary valueForKey:@"results"] count]; i++)
                    [arrayUsedInTable addObject:[Dictionary valueForKey:@"results"][i]];
                
                [self.agendaPostsTableView reloadData];
                
                [spinnerview endRefreshing];
                
                CGRect frame = self.agendaPostsTableView.frame;
                frame.size.height = self.agendaPostsTableView.contentSize.height;
                self.agendaPostsTableView.frame = frame;
                
                
               
                self.agendaScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.agendaPostsTableView.frame.origin.y + self.agendaPostsTableView.frame.size.height + self.noArticle.frame.size.height * 0.5);
                
                
                }
                else {
//                        [self showMessage:@"aucun événement à venir!"];
//                        self.dossiersTable.frame = CGRectMake(self.dossiersTable.frame.origin.x, self.dossiersHeaderView.frame.origin.y, self.dossiersTable.frame.size.width, self.dossiersTable.frame.size.height);
//                        self.dossiersHeaderView.hidden = true;
//                        self.closeDossiersView.hidden = true;
//                        self.agendaScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.dossiersView.frame.origin.y + self.dossiersTable.frame.size.height + self.noArticle.frame.size.height * 0.5);
//                         [spinnerview endRefreshing];
//                    self.nosDossires.hidden = true;
//                  self.slugLabel.text = @"Nos dossiers";
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alerte"
                                                                    message:@"Aucun événement prévu actuellement !"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                   //  [self showMessage:@"Aucun évènement n'est prévu pour le moment!"];
                }
                [spinnerview endRefreshing];
            });
        });
        
        
        
    }
    else if (agendaInfosArray.count != 0){
        self.noArticle.hidden = true;
    [self.dossiersView removeFromSuperview];
    self.agendaScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.agendaContentView.frame.origin.y + self.agendaContentView.frame.size.height + self.noArticle.frame.size.height * 1.1);
    self.searchfieldView.hidden = NO;
        
    }
    else {
         dispatch_async(dispatch_get_main_queue(), ^{
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alerte"
                                                             message:@"Aucun événement prévu actuellement !"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
            // [self showMessage:@"Aucun évènement n'est prévu pour le moment!"];
            // [spinnerview endRefreshing];
             });
        [spinnerview endRefreshing];
    }
    
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
                
                // NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
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
-(void)showMessage: (NSString *)content{
    
    OLGhostAlertView *demo = [[OLGhostAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", content] message:nil timeout:1 dismissible:YES];
    demo.titleLabel.font = [UIFont fontWithName:@"Montserrat-Light" size:14.0 ];
    demo.titleLabel.textColor = [UIColor whiteColor];
    demo.backgroundColor =  [UIColor colorWithRed:59/255.0f green:169/255.0f blue:206/255.0f alpha:1.0f];;
    demo.bottomContentMargin = self.view.frame.size.height/2 + 40;
    demo.layer.cornerRadius = 7;
    
    [demo show];
    
    
}
-(void)sendingAnHTTGETTRequestCategoryClicked: (NSString *)url{
    
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
    
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    
    
    Dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
    
    
    
    
}
- (IBAction)reloadScreen:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"AgendaViewController"]];
}
@end
