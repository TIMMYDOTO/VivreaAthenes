//
//  AgendaArticlePopUp.h
//  VivreABerlin
//
//  Created by home on 30/07/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgendaArticlePopUp : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UIImageView *articleimage;
@property (weak, nonatomic) IBOutlet UILabel *articleDate;
@property (weak, nonatomic) IBOutlet UILabel *articleCategory;
@property (weak, nonatomic) IBOutlet UILabel *endroidCategory;
@property (weak, nonatomic) IBOutlet UILabel *articleQuartier;
@property (weak, nonatomic) IBOutlet UILabel *articlePrix;
@property (weak, nonatomic) IBOutlet UILabel *articleHeure;
- (IBAction)articleWebsite:(id)sender;
- (IBAction)articleMap:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *webSitetitle;
@property (weak, nonatomic) IBOutlet UILabel *mapTitle;
@property (weak, nonatomic) IBOutlet UILabel *imageCaption;
- (IBAction)closePopUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *popUpview;
@property (weak, nonatomic) IBOutlet UILabel *articleVideo;


@end
