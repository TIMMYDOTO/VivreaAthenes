//
//  LeftViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"
#import "MenuCell.h"
#import "ViewController.h"
#import "MainViewController.h"
#import "GlobalVariables.h"
#import "Header.h"
#import "Reachability.h"
#import "SimpleFilesCache.h"
#import "MenuCell.h"
#import "SubMenuCell.h"
#import "JTMaterialSpinner.h"
#import "ContainerViewController.h"
@interface LeftViewController (){
    
 
}




@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation LeftViewController
{
    
    NSString *flag;
    NSMutableArray *arr;
    
    
  
    NSMutableArray * MenuArray;
    NSMutableArray * offlineMenuArray;
    NSMutableArray * arrayForTable;
    NSMutableArray * filteredTableData;
    JTMaterialSpinner *searchSpinner;
    
  
    BOOL once;
    
    CGRect posFrame;
    CGFloat originOfCatsTable;
    
    NSString * textSearchedAfterASecond;
    
    __weak IBOutlet UIView *viewForSocialLinks;
}


- (void) viewDidLoad {
    if ([AppName isEqualToString:@"Athènes"]) {
        [_instagram setImage:[UIImage imageNamed:@"pinterest"]];
        [_twitter setImage:nil];
    
    }
    arr = [[NSMutableArray alloc]init];
    self.accueilText.text = [NSString stringWithFormat:@"Vivre %@",AppName];
    
    self.accueilText.adjustsFontSizeToFitWidth = true;
    self.settingsText.adjustsFontSizeToFitWidth = true;
    self.contactEtCreditsText.adjustsFontSizeToFitWidth = true;
    self.noArticlesFound.adjustsFontSizeToFitWidth = true;

    
    searchSpinner = [[JTMaterialSpinner alloc] init];
    [self.quickSearchView addSubview:searchSpinner];
    [self.quickSearchView bringSubviewToFront:searchSpinner];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    searchSpinner.frame = CGRectMake(self.view.frame.size.width * 0.3, self.view.frame.size.height * 0.1, 30, 30);
    else
    searchSpinner.frame = CGRectMake(self.view.frame.size.width * 0.175, self.view.frame.size.height * 0.1, 30, 30);
    searchSpinner.circleLayer.lineWidth = 3.0;
    searchSpinner.circleLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.noArticlesFound.hidden = YES;

    originOfCatsTable = self.catAndSubcatsTable.frame.origin.y;
    
    self.SeeAllResults.layer.borderColor = [UIColor whiteColor].CGColor;
    self.SeeAllResults.layer.borderWidth = 2;
    
    self.quickSearchView.hidden = YES;
    
    self.resultsSearchTable.delegate = self;
    self.resultsSearchTable.dataSource = self;
    self.resultsSearchTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.resultsSearchTable.backgroundColor = [UIColor colorWithRed:37/255.0f green:43/255.0f blue:54/255.0f alpha:1];
    self.quickSearchView.backgroundColor = [UIColor colorWithRed:37/255.0f green:43/255.0f blue:54/255.0f alpha:1];
    self.seeAll.layer.cornerRadius = 5;
    
    self.searchArticles.backgroundColor = [UIColor clearColor];
    self.searchArticles.barStyle = UIBarStyleBlackTranslucent;
    self.searchArticles.placeholder = @"Je cherche...";
    self.searchArticles.barTintColor = [UIColor whiteColor];
    self.searchArticles.backgroundImage = [self imageFromColor:[UIColor colorWithRed:37/255.0f green:43/255.0f blue:54/255.0f alpha:1]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    CGRect newFrameForSearch = self.searchArticles.frame;
    newFrameForSearch.size.width += 16;
    newFrameForSearch.origin.x -= 8;
    newFrameForSearch.size.height = 100;
    self.searchArticles.frame = newFrameForSearch;
    self.searchArticles.alpha = 0.0f;
    }
    else {
      self.searchArticles.alpha = 0.0f;
    }
    
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    posFrame = self.socialsView.frame;
    posFrame.size.width = self.socialsView.frame.size.width * 0.7;
     }
    
    self.searchArticles.delegate = self;
   
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(hideQuickSearchView:) name:@"CloseKeyboard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(ReloadTable) name:@"ReloadTable" object:nil];
    self.logoAppIcon.image = [UIImage imageNamed:@"logo1"];
    self.logoAppIcon.clipsToBounds = true;
    self.logoAppIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.view bringSubviewToFront:self.logoAppIcon];
    
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0f green:43/255.0f blue:54/255.0f alpha:1];
    self.catAndSubcatsTable.backgroundColor = [UIColor clearColor];
    


    [self newLoad];
    
    
}

-(void)newLoad {
    offlineMenuArray = [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"menuDictionary"]];
    
    
    
    if(offlineMenuArray.count != 0) {
        arrayForTable = [[NSMutableArray alloc] init];
        [offlineMenuArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[obj valueForKey:@"order"]integerValue] >= 92)  {
                *stop = YES;
            }


            [arrayForTable addObject:obj];
            [arrayForTable setValue:nil forKey:@"isExpanded"];
        }];
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSDictionary *dict in arrayForTable) {
            NSMutableDictionary *currentDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
            
            NSArray *oldChildren = currentDictionary[@"children"];
            NSMutableArray *children = [NSMutableArray array];
            if (oldChildren!=nil && [oldChildren count]>0) {
                for (NSDictionary *child in oldChildren) {
                    NSString *classes = child[@"classes"];
                    if (classes!=nil && [classes isEqualToString:@""] == NO && [classes containsString:@"dgab-force-display"]) {
                        [children addObject:child];
                    }
                }
            }
            [currentDictionary setObject:children forKey:@"children"];
            [arr addObject:currentDictionary];
        }
        arrayForTable = arr;
        
  
        
        for ( int i = 0 ; i <arrayForTable.count; i ++) {
        
            if([[arrayForTable valueForKey:@"parent"][i] integerValue] == 0)
            {
                
                [arrayForTable setValue:@"0" forKey:@"level"];
                
                
                
                
                if([[arrayForTable[i] valueForKey:@"children"] count] > 0)
                    [arrayForTable setValue:@"YES" forKey:@"CanBeExpanded"];
                
                
                
                
                for (int j = 0 ; j <[NSMutableArray arrayWithArray:[arrayForTable[i] valueForKey:@"children"]].count; j++) {
                    
                    [[arrayForTable[i] valueForKey:@"children"][j] setValue:@"1" forKey:@"level"];
                    
                    [[arrayForTable[i] valueForKey:@"children"][j] setValue:[arrayForTable valueForKey:@"category_color"][i] forKey:@"category_color"];
                    
                    if([NSMutableArray arrayWithArray:[[arrayForTable[i] valueForKey:@"children"][j] valueForKey:@"children"]].count != 0) {
                        [[arrayForTable[i] valueForKey:@"children"][j] setValue:@"YES" forKey:@"CanBeExpanded"];
                        
                        for( int p = 0 ; p < [NSMutableArray arrayWithArray:[[arrayForTable[i] valueForKey:@"children"][j] valueForKey:@"children"]].count; p++) {
                            
                            [[[arrayForTable[i] valueForKey:@"children"][j] valueForKey:@"children"][p] setValue:[arrayForTable valueForKey:@"category_color"][i] forKey:@"category_color"];
                        }
                    }
                }
                
                for (int x = 0 ; x < [NSMutableArray arrayWithArray:[[arrayForTable valueForKey:@"children"][i] valueForKey:@"children"]].count; x++){
                    
                    [[[arrayForTable valueForKey:@"children"][i] valueForKey:@"children"][x] setValue:@"2" forKey:@"level"];
                }
                
                
                
            }
            
            
        }
        
        if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                [self makingRequest:sideMenuLink];
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable))
                        [SimpleFilesCache saveToCacheDirectory:[NSKeyedArchiver archivedDataWithRootObject:MenuArray] withName:@"menuDictionary"];
                    
                });
            });
        }
        
        
        
        
    }
    else{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            
            [self makingRequest:sideMenuLink];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:MenuArray];
                [SimpleFilesCache saveToCacheDirectory:data withName:@"menuDictionary"];
                offlineMenuArray = [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"menuDictionary"]];
                
                arrayForTable = [[NSMutableArray alloc] init];
                NSLog(@"count: %lu", [[offlineMenuArray valueForKey:@"parent"]count]);
                for ( int i = 0 ; i<=8;i ++) {
                    if([[offlineMenuArray valueForKey:@"parent"][i] integerValue] == 0)
                    {
                        [arrayForTable addObject:offlineMenuArray[i]];
                        NSLog(@"arrayForTable %@", arrayForTable);
                    }
                    
                }
                
                for ( int i = 0 ; i<=8;i ++) {
                    if([[arrayForTable valueForKey:@"parent"][i] integerValue] == 0)
                    {
                        
                        [arrayForTable setValue:@"0" forKey:@"level"];
                        
                        if([[arrayForTable[i] valueForKey:@"children"] count] > 0)
                            [arrayForTable setValue:@"YES" forKey:@"CanBeExpanded"];
                        
                        
                        
                        for (int j = 0 ; j <[NSMutableArray arrayWithArray:[arrayForTable[i] valueForKey:@"children"]].count; j++) {
                            
                            [[arrayForTable[i] valueForKey:@"children"][j] setValue:@"1" forKey:@"level"];
                            [[arrayForTable[i] valueForKey:@"children"][j] setValue:[arrayForTable valueForKey:@"category_color"][i] forKey:@"category_color"];
                            
                            if([NSMutableArray arrayWithArray:[[arrayForTable[i] valueForKey:@"children"][j] valueForKey:@"children"]].count != 0) {
                                [[arrayForTable[i] valueForKey:@"children"][j] setValue:@"YES" forKey:@"CanBeExpanded"];
                                
                                for( int p = 0 ; p < [NSMutableArray arrayWithArray:[[arrayForTable[i] valueForKey:@"children"][j] valueForKey:@"children"]].count; p++) {
                                    
                                    [[[arrayForTable[i] valueForKey:@"children"][j] valueForKey:@"children"][p] setValue:[arrayForTable valueForKey:@"category_color"][i] forKey:@"category_color"];
                                }
                                
                            }
                        }
                        
                        for (int x = 0 ; x < [NSMutableArray arrayWithArray:[[arrayForTable valueForKey:@"children"] valueForKey:@"children"]].count; x++){
                            
                            [[[arrayForTable valueForKey:@"children"] valueForKey:@"children"][x] setValue:@"2" forKey:@"level"];
                        }
                        
                        
                        
                    }
                    
                    
                }
                
                [self.catAndSubcatsTable reloadData];
                
            });
        });
        
    }
}
-(void)ReloadTable{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [self newLoad];
    [self.catAndSubcatsTable reloadData];
        [self.catAndSubcatsTable setContentOffset:CGPointMake(0, 0)];
        
    });

}

-(void)hideQuickSearchView:(NSNotification *)notifaction{
    if([notifaction.object isEqualToString:@"JustCloseKeyboard"]){
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [UIView animateWithDuration:0.3
                animations:^{self.quickSearchView.alpha = 0.0;}
                     completion:^(BOOL finished){ self.quickSearchView.hidden = YES; }];
    [UIView animateWithDuration:0.2
                     animations:^{self.catAndSubcatsTable.frame = CGRectMake(self.catAndSubcatsTable.frame.origin.x, originOfCatsTable, self.catAndSubcatsTable.frame.size.width, self.catAndSubcatsTable.frame.size.height);
                     }
                     completion:^(BOOL finished){ }];
    }
    else if([notifaction.object isEqualToString:@"AndCloseSearchBar"]){
        
        if(self.socialsView.frame.origin.x < 0){
            
            [UIView animateWithDuration:0.3 animations:^{
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                self.searchArticles.alpha = 0;
                CGRect frame = self.searchArticles.frame;
                frame.origin.x = -400;
                self.searchArticles.frame = frame;
                self.openSearchBar.userInteractionEnabled = false;
                }
                else {
                    self.searchArticles.alpha = 0;
                    self.openSearchBar.userInteractionEnabled = false;
                }
                
            }completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                    self.socialsView.frame = posFrame;
                    self.socialsView.alpha = 1;
                     }
                     else {
                         self.socialsView.alpha = 1;
                     }
                    
                    
                }completion:^(BOOL finished) {
                    self.openSearchBar.userInteractionEnabled = true;
                    [NSObject cancelPreviousPerformRequestsWithTarget:self];
                    [self.searchArticles resignFirstResponder];
                    [UIView animateWithDuration:0.2
                                     animations:^{self.quickSearchView.alpha = 0.0;}
                                     completion:^(BOOL finished){ self.quickSearchView.hidden = YES; }];
                    [UIView animateWithDuration:0.3
                                     animations:^{self.catAndSubcatsTable.frame = CGRectMake(self.catAndSubcatsTable.frame.origin.x, originOfCatsTable, self.catAndSubcatsTable.frame.size.width, self.catAndSubcatsTable.frame.size.height);
                                     }
                                     completion:^(BOOL finished){ }];
                    
                    [GlobalVariables getInstance].isUserSearchingOnSideBar = NO;
                }];
                
                
                
                
            }];
            
            once = NO;

        }
        
    }
    else{
        self.searchArticles.text = [NSString stringWithFormat:@"%@",notifaction.object];
        [GlobalVariables getInstance].textSearched = [NSString stringWithFormat:@"%@",notifaction.object];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(tableView == self.catAndSubcatsTable){
        return arrayForTable.count ;
    }
    else
        return filteredTableData.count;
}
-(bool)sendingAnHTTGETTRequestCategoryClicked: (NSString *)url diction:(NSDictionary *)diction{
    
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
    
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
//    NSLog(@"dict: %@", [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError]);
   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    if ([dict valueForKey:@"results"] == [NSNull null]) {
      return false;
    }
    else {
        return true;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

  
    if(tableView == self.catAndSubcatsTable){
        if (indexPath.row == arrayForTable.count-1) {
            cell.separator.backgroundColor = [UIColor clearColor];
        }
            cell.categoriesName.text =[[arrayForTable objectAtIndex:indexPath.row] valueForKey:@"title"];
 
        cell.indentationWidth = 20;
        [cell setIndentationLevel:[[[arrayForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
        
        if (cell.indentationLevel == 0) {
            
            
            if([[[arrayForTable objectAtIndex:indexPath.row] valueForKey:@"CanBeExpanded"] boolValue] == YES && indexPath.row != 0){
                
                cell.expandCell.image =  [UIImage imageNamed:@"sideBarArrowww.png"];
                
                
                [cell.checkedCategory addTarget:self
                                         action:@selector(ClickCategory:)
                               forControlEvents:UIControlEventTouchUpInside];
                cell.checkedCategory.tag = indexPath.row;
                cell.checkedCategory.hidden = false;
                
                if([[[arrayForTable objectAtIndex: indexPath.row] valueForKey:@"isExpanded"] isEqualToString:@"YES"]){
                    cell.expandCell.image =  [UIImage imageNamed:@"openSubCats"];
                    
                }
            }
            else {
                cell.checkedCategory.hidden = YES;
                cell.expandCell.image = nil;
                
                
            }
            
            
            cell.categoriesName.textColor = [self colorWithHexString:[[NSString stringWithFormat:@"%@",[[arrayForTable objectAtIndex:indexPath.row] valueForKey:@"category_color"]]
                                                                      stringByReplacingOccurrencesOfString:@"#" withString:@""]];
            
            cell.descriptivePicture.image = [UIImage imageNamed:[[arrayForTable objectAtIndex:indexPath.row] valueForKey:@"title"]];
            if([[[arrayForTable objectAtIndex:indexPath.row] valueForKey:@"title"] isEqualToString:@"S'échapper"] ){
                cell.descriptivePicture.image = [UIImage imageNamed:@"Sechapper"];
            }
            NSLog(@"title %@", [[arrayForTable objectAtIndex:indexPath.row] valueForKey:@"title"]);
            
            cell.descriptivePicture.contentMode = UIViewContentModeScaleAspectFit;
            cell.descriptivePicture.clipsToBounds = true;
            
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            UIFont *fontt = [UIFont fontWithName:@"Montserrat-Regular" size:27.f];
            cell.categoriesName.font = fontt;
            }
            else{
                UIFont *fontt = [UIFont fontWithName:@"Montserrat-Regular" size:17.f];
                cell.categoriesName.font = fontt;
            }
            
            cell.categoriesName.numberOfLines = 1;
            cell.categoriesName.adjustsFontSizeToFitWidth = true;
            cell.categoriesName.textColor = [UIColor whiteColor];
            
            cell.backgroundColor = [UIColor colorWithRed:37/255.0f green:43/255.0f blue:54/255.0f alpha:1];
            return  cell;
            
        }
        else if (cell.indentationLevel == 1){
            
            
            cell.descriptivePicture.image = nil;
            
             if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            UIFont *fontt = [UIFont fontWithName:@"Montserrat-Regular" size:27.f];
            cell.categoriesName.font = fontt;
             }
             else{
                 UIFont *fontt = [UIFont fontWithName:@"Montserrat-Regular" size:17.f];
                 cell.categoriesName.font = fontt;
             }
            
            cell.categoriesName.numberOfLines = 2;
            cell.categoriesName.adjustsFontSizeToFitWidth = true;
            
            
            if([[[arrayForTable objectAtIndex:indexPath.row] valueForKey:@"CanBeExpanded"] boolValue] == YES){
                
                cell.expandCell.image =  [UIImage imageNamed:@"sideBarArrowww.png"];
                
                [cell.checkedCategory addTarget:self
                                         action:@selector(ClickCategory:)
                               forControlEvents:UIControlEventTouchUpInside];
                cell.checkedCategory.tag = indexPath.row;
                cell.checkedCategory.hidden = false;
                
                if([[[arrayForTable objectAtIndex: indexPath.row] valueForKey:@"isExpanded"] isEqualToString:@"YES"]){
                    cell.expandCell.image =  [UIImage imageNamed:@"openSubCats"];
                    
                }
            }
            else {
                cell.expandCell.image =  nil;
                cell.checkedCategory.hidden = YES;
                
                
            }
            cell.categoriesName.textColor = [UIColor whiteColor];
            
            cell.backgroundColor = [UIColor colorWithRed:37/255.0f green:43/255.0f blue:54/255.0f alpha:1];
            
            return  cell;
            
}
        else if (cell.indentationLevel == 2){
            
            
            cell.imageView.image = nil;
            
            cell.descriptivePicture.image = nil;
            
            cell.expandCell.image =  nil;
            
            static NSString *CellIdentifier = @"SubMenuCell";
            
            SubMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
           

            
            cell.subMenuCategoryname.text=[[arrayForTable objectAtIndex:indexPath.row] valueForKey:@"title"];
           
             if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
                 UIFont *fontt = [UIFont fontWithName:@"Montserrat-Regular" size:27.f];
                 cell.subMenuCategoryname.font = fontt;
             }
             else{
                 UIFont *fontt = [UIFont fontWithName:@"Montserrat-Regular" size:17.f];
                 cell.subMenuCategoryname.font = fontt;
                 }
            
            cell.subMenuCategoryname.numberOfLines = 2;
            cell.subMenuCategoryname.adjustsFontSizeToFitWidth = true;
            
            cell.subMenuCategoryname.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor colorWithRed:37/255.0f green:43/255.0f blue:54/255.0f alpha:1];
            
            return cell;
            
        }
    }
        else{
            static NSString *simpleTableIdentifier = @"SimpleTableItem";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            
            
            if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
                cell.textLabel.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[filteredTableData valueForKey:@"title"][indexPath.row]]];
            }
            else {
                cell.textLabel.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[filteredTableData valueForKey:@"post_title"][indexPath.row]]];
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.numberOfLines = 2;
        
             if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            cell.textLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:25];
            else
                cell.textLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:15];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
 
            [tableView setSeparatorColor:[UIColor grayColor]];
            tableView.showsHorizontalScrollIndicator = false;
            return cell;
        }
        
    
    return cell;
}

- (void) ClickCategory: (UIButton*) button {
    if(button.tag == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"ViewController"]];
        [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
        
        
    }
    else if([self.searchArticles isFirstResponder]){
        [self.searchArticles resignFirstResponder];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [UIView animateWithDuration:0.2
                         animations:^{self.quickSearchView.alpha = 0.0;}
                         completion:^(BOOL finished){ self.quickSearchView.hidden = YES; }];
        [GlobalVariables getInstance].isUserSearchingOnSideBar = NO;
        [UIView animateWithDuration:0.3
                         animations:^{self.catAndSubcatsTable.frame = CGRectMake(self.catAndSubcatsTable.frame.origin.x, originOfCatsTable, self.catAndSubcatsTable.frame.size.width, self.catAndSubcatsTable.frame.size.height);
                         }
                         completion:^(BOOL finished){ }];
        

    }
    else{
        NSInteger tag = button.tag;
        
      
        
        [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
        ///////////////////
        [GlobalVariables getInstance].idOfcatSubCat = [[arrayForTable objectAtIndex:tag] valueForKey:@"object_id"];
        [GlobalVariables getInstance].nameOfcatSubCat = [[arrayForTable objectAtIndex:tag] valueForKey:@"title"];
       

        
        if([[GlobalVariables getInstance].allCategoriesName containsObject:[[arrayForTable objectAtIndex:tag] valueForKey:@"title"]]){
            
             [GlobalVariables getInstance].categoryColor = [colorsInSideBar objectAtIndex:tag];
            [GlobalVariables getInstance].subCatSlugNumber = [[GlobalVariables getInstance].allCategoriesSlugs objectAtIndex:[[GlobalVariables getInstance].allCategoriesName indexOfObject:[[arrayForTable objectAtIndex:tag] valueForKey:@"title"]]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ComingFromPostTag"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ComingFromAgendaTag"];
        [GlobalVariables getInstance].backGroundImageTag = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"CatsSubCatsController"]];
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.catAndSubcatsTable){
        if([self.searchArticles isFirstResponder]){
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            [self.searchArticles resignFirstResponder];
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [UIView animateWithDuration:0.2
                             animations:^{self.quickSearchView.alpha = 0.0;}
                             completion:^(BOOL finished){ self.quickSearchView.hidden = YES; }];
            [UIView animateWithDuration:0.3
                             animations:^{self.catAndSubcatsTable.frame = CGRectMake(self.catAndSubcatsTable.frame.origin.x, originOfCatsTable, self.catAndSubcatsTable.frame.size.width, self.catAndSubcatsTable.frame.size.height);
                             }
                             completion:^(BOOL finished){ }];

            [GlobalVariables getInstance].isUserSearchingOnSideBar = NO;
        }
        else {
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSDictionary *d=[arrayForTable objectAtIndex:indexPath.row];
            
            if([[d valueForKey:@"level"] isEqualToString:@"0"])
            [GlobalVariables getInstance].categoryColor = [colorsInSideBar objectAtIndex:indexPath.row];
            
            if([[GlobalVariables getInstance].allCategoriesName containsObject:[d valueForKey:@"title"]]){
                
                [GlobalVariables getInstance].subCatSlugNumber = [[GlobalVariables getInstance].allCategoriesSlugs objectAtIndex:[[GlobalVariables getInstance].allCategoriesName indexOfObject:[d valueForKey:@"title"]]];
            }
            
            if([d valueForKey:@"children"]) {
                NSArray *ar=[d valueForKey:@"children"];
                
                BOOL isAlreadyInserted=NO;
                
                for(NSDictionary *dInner in ar ){
                    NSInteger index=[arrayForTable indexOfObjectIdenticalTo:dInner];
                    isAlreadyInserted=(index>0 && index!=NSIntegerMax);
                    if(isAlreadyInserted) break;
                    
                    
                }
                if(ar.count == 0){
                
                    if([[d valueForKey:@"title"] isEqualToString:@"Accueil"]){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"ViewController"]];
                        [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
                    }
                    else if([[d valueForKey:@"title"] isEqualToString:@"Petites annonces"]){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"AnnouncementsViewController"]];
                        [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
                    }
                    else if([[d valueForKey:@"title"] isEqualToString:@"Agenda de Berlin"]){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"AgendaViewController"]];
                        [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
                    }
                    else{
                        [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];

                        [GlobalVariables getInstance].idOfcatSubCat = [d valueForKey:@"object_id"];
                        
                        
                        
                        [GlobalVariables getInstance].nameOfcatSubCat = [d valueForKey:@"title"];
                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ComingFromPostTag"];
                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ComingFromAgendaTag"];
                        [GlobalVariables getInstance].backGroundImageTag = nil;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"CatsSubCatsController"]];
                    
                    }
                }
                if(isAlreadyInserted) {
                    [[arrayForTable objectAtIndex: indexPath.row] setValue:@"NO" forKey:@"isExpanded"];
                    [self miniMizeThisRows:ar];
                    
                } else {
                    NSUInteger count=indexPath.row+1;
                    NSMutableArray *arCells=[NSMutableArray array];
                    for(NSDictionary *dInner in ar ) {
                        [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                        [arrayForTable insertObject:dInner atIndex:count++];
                    }
                    [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
                    [[arrayForTable objectAtIndex: indexPath.row] setValue:@"YES" forKey:@"isExpanded"];
                    [tableView reloadData];
                    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    
                }
            }
        }
    }
    else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [GlobalVariables getInstance].isUserSearchingOnSideBar = NO;
        [self.searchArticles resignFirstResponder];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [UIView animateWithDuration:0.2
                         animations:^{self.quickSearchView.alpha = 0.0;}
                         completion:^(BOOL finished){ self.quickSearchView.hidden = YES; }];
        [UIView animateWithDuration:0.3
                         animations:^{self.catAndSubcatsTable.frame = CGRectMake(self.catAndSubcatsTable.frame.origin.x, originOfCatsTable, self.catAndSubcatsTable.frame.size.width, self.catAndSubcatsTable.frame.size.height);
                         }
                         completion:^(BOOL finished){ }];

        [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
         if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable))
            [GlobalVariables getInstance].idOfPost = [[filteredTableData valueForKey:@"id"][indexPath.row]stringValue];
        else
        [GlobalVariables getInstance].idOfPost = [[filteredTableData valueForKey:@"post_id"][indexPath.row]stringValue];;
        [GlobalVariables getInstance].comingFrom = @"Search";

        [GlobalVariables getInstance].comingFromViewController = @"ListOfPostsController";
        [GlobalVariables getInstance].CarouselOfPostIds = [[NSMutableArray alloc] initWithArray: @[[NSString stringWithFormat:@"%@",[GlobalVariables getInstance].comingFromViewController]]];
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"CanAddObjectToCarousel"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PostViewController"]];
        

        
        
    }
}

-(void)miniMizeThisRows:(NSArray*)ar{
    
    for(NSDictionary *dInner in ar ) {
        NSUInteger indexToRemove=[arrayForTable indexOfObjectIdenticalTo:dInner];
        NSArray *arInner=[dInner valueForKey:@"children"];
        if(arInner && [arInner count]>0){
            [self miniMizeThisRows:arInner];
        }
        
        if([arrayForTable indexOfObjectIdenticalTo:dInner]!=NSNotFound) {
            [arrayForTable removeObjectIdenticalTo:dInner];
            [self.catAndSubcatsTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                             [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                             ]
                                           withRowAnimation:UITableViewRowAnimationRight];
        }
    }
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.catAndSubcatsTable reloadData];
        //[self.catAndSubcatsTable setContentOffset:CGPointMake(0, 0) animated:YES];
        
    });
    
}

-(void)makingRequest:(NSString *)url
{
    
    NSURL *jsonFileUrl = [[NSURL alloc] initWithString:url];
    
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
        MenuArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
        [[NSUserDefaults standardUserDefaults] setValue:@"false" forKey:@"isFirstTimeHere"];
    }
}

- (IBAction)openAppsPopup:(id)sender {
    
    
    
    [kMainViewController hideLeftViewAnimated:NO completionHandler:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"PopUpButtonClickedOnLeftController" object: [NSString stringWithFormat:@"OpenPopUp"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PopUpApplications"]];
}

- (IBAction)toMap:(id)sender {
    
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"MapViewController"]];
}

- (IBAction)InapoiLaPaginaPrincipala:(id)sender {
    [self.searchArticles resignFirstResponder];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.catAndSubcatsTable setContentOffset:CGPointMake(0, 3) animated:YES];
    [UIView animateWithDuration:0.2
                     animations:^{self.quickSearchView.alpha = 0.0;}
                     completion:^(BOOL finished){ self.quickSearchView.hidden = YES; }];
    [UIView animateWithDuration:0.3
                     animations:^{self.catAndSubcatsTable.frame = CGRectMake(self.catAndSubcatsTable.frame.origin.x, originOfCatsTable, self.catAndSubcatsTable.frame.size.width, self.catAndSubcatsTable.frame.size.height);
                     }
                     completion:^(BOOL finished){ }];

    [GlobalVariables getInstance].isUserSearchingOnSideBar = NO;
    if (once != YES){
        [UIView animateWithDuration:0.3 animations:^{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            CGRect frame = self.socialsView.frame;
            frame.origin.x = -400;
//            self.socialsView.frame = frame;
            self.socialsView.alpha = 0;
             
                viewForSocialLinks.alpha = 0;
                
            self.openSearchBar.userInteractionEnabled = false;
            }
            else {
                self.socialsView.alpha = 0;
                self.openSearchBar.userInteractionEnabled = false;
            }
            
        }completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 animations:^{
                 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                self.searchArticles.frame = posFrame;
                self.searchArticles.alpha = 1;
                [self.searchArticles becomeFirstResponder];
                 }
                 else {
                     self.searchArticles.alpha = 1;
                     [self.searchArticles becomeFirstResponder];
                 }
                
                
                
            }completion:^(BOOL finished) {
                self.openSearchBar.userInteractionEnabled = true;
                
                if([self.searchArticles.text length] > 0){
                self.quickSearchView.hidden = false;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"textChanged" object: self.searchArticles.text];
                
                [UIView animateWithDuration:0.3
                                 animations:^{self.catAndSubcatsTable.frame = CGRectMake(self.catAndSubcatsTable.frame.origin.x, self.quickSearchView.frame.origin.y + self.quickSearchView.frame.size.height + 5, self.catAndSubcatsTable.frame.size.width, self.catAndSubcatsTable.frame.size.height);
                                 }
                                 completion:^(BOOL finished){ }];
                
                
                if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
                    [NSObject cancelPreviousPerformRequestsWithTarget:self];
                    [searchSpinner beginRefreshing];
                    [self performSelector:@selector(searchArticle) withObject:self.searchArticles.text afterDelay:0.75f];
                    
                }
                else{
                    [self performSelector:@selector(searchArticle) withObject:self.searchArticles.text afterDelay:0.001f];
                }

                }
            }];
            
            
        }];
        once = YES;
    }
    else {
        
        [UIView animateWithDuration:0.3 animations:^{
             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            self.searchArticles.alpha = 0;
            CGRect frame = self.searchArticles.frame;
            frame.origin.x = -400;
            self.searchArticles.frame = frame;
            self.openSearchBar.userInteractionEnabled = false;
             }
             else {
                 self.searchArticles.alpha = 0;
                 self.openSearchBar.userInteractionEnabled = false;
             }
            
        }completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 animations:^{
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                self.socialsView.frame = posFrame;
                self.socialsView.alpha = 1;
                viewForSocialLinks.alpha = 1;
                
                
            }completion:^(BOOL finished) {
                self.openSearchBar.userInteractionEnabled = true;
                [self.searchArticles resignFirstResponder];
                [UIView animateWithDuration:0.2
                                 animations:^{self.quickSearchView.alpha = 0.0;}
                                 completion:^(BOOL finished){ self.quickSearchView.hidden = YES; }];
                [UIView animateWithDuration:0.3
                                 animations:^{self.catAndSubcatsTable.frame = CGRectMake(self.catAndSubcatsTable.frame.origin.x, originOfCatsTable, self.catAndSubcatsTable.frame.size.width, self.catAndSubcatsTable.frame.size.height);
                                 }
                                 completion:^(BOOL finished){ }];

                [GlobalVariables getInstance].isUserSearchingOnSideBar = NO;
            }];
            
            
            
            
        }];
        
        once = NO;
        
    }
    
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
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchSpinner beginRefreshing];
    
    [UIView animateWithDuration:0.3
                     animations:^{self.catAndSubcatsTable.frame = CGRectMake(self.catAndSubcatsTable.frame.origin.x, self.quickSearchView.frame.origin.y + self.quickSearchView.frame.size.height + 5, self.catAndSubcatsTable.frame.size.width, self.catAndSubcatsTable.frame.size.height);
                     }
                     completion:^(BOOL finished){ }];
    
    
    
    self.noArticlesFound.hidden = YES;
    
    
    [self searchArticle];
    
    [GlobalVariables getInstance].textSearched = self.searchArticles.text;
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    

    [self.catAndSubcatsTable setContentOffset:CGPointMake(0, 3) animated:YES];
    
    self.quickSearchView.hidden = false;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"textChanged" object: searchText];
    
    [UIView animateWithDuration:0.3
                     animations:^{self.catAndSubcatsTable.frame = CGRectMake(self.catAndSubcatsTable.frame.origin.x, self.quickSearchView.frame.origin.y + self.quickSearchView.frame.size.height + 5, self.catAndSubcatsTable.frame.size.width, self.catAndSubcatsTable.frame.size.height);
                     }
                     completion:^(BOOL finished){ }];
    
    
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
   [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [searchSpinner beginRefreshing];
    [self performSelector:@selector(searchArticle) withObject:searchText afterDelay:0.75f];
    
    }
    else{
        [self performSelector:@selector(searchArticle) withObject:searchText afterDelay:0.001f];
    }
    
}

- (IBAction)openFacebook:(id)sender {
    
    
    [self.searchArticles resignFirstResponder];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [UIView animateWithDuration:0.2
                     animations:^{self.quickSearchView.alpha = 0.0;}
                     completion:^(BOOL finished){ self.quickSearchView.hidden = YES; }];
    [GlobalVariables getInstance].isUserSearchingOnSideBar = NO;
    [UIView animateWithDuration:0.3
                     animations:^{self.catAndSubcatsTable.frame = CGRectMake(self.catAndSubcatsTable.frame.origin.x, originOfCatsTable, self.catAndSubcatsTable.frame.size.width, self.catAndSubcatsTable.frame.size.height);
                     }
                     completion:^(BOOL finished){ }];
    

    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.facebook.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2 , 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            self.facebook.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                self.facebook.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:facebookSocial]])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:facebookSocial]];
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR"
                                                            message:@"Ce réseau social n'a pas encore été installé"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
        
    });
    
}

- (IBAction)openTwitter:(id)sender {
    if ([AppName isEqualToString:@"Athènes"]) {
        return ;
    }
    [self.searchArticles resignFirstResponder];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [UIView animateWithDuration:0.2
                     animations:^{self.quickSearchView.alpha = 0.0;}
                     completion:^(BOOL finished){ self.quickSearchView.hidden = YES; }];
    [GlobalVariables getInstance].isUserSearchingOnSideBar = NO;
    [UIView animateWithDuration:0.3
                     animations:^{self.catAndSubcatsTable.frame = CGRectMake(self.catAndSubcatsTable.frame.origin.x, originOfCatsTable, self.catAndSubcatsTable.frame.size.width, self.catAndSubcatsTable.frame.size.height);
                     }
                     completion:^(BOOL finished){ }];


    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.twitter.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2 , 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            self.twitter.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                self.twitter.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:twitterSocial]])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitterSocial]];
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR"
                                                            message:@"Ce réseau social n'a pas encore été installé"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];

        }
    });
}

- (IBAction)openInstagram:(id)sender {
    [self.searchArticles resignFirstResponder];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [UIView animateWithDuration:0.2
                     animations:^{self.quickSearchView.alpha = 0.0;}
                     completion:^(BOOL finished){ self.quickSearchView.hidden = YES; }];
    
    [UIView animateWithDuration:0.3
                     animations:^{self.catAndSubcatsTable.frame = CGRectMake(self.catAndSubcatsTable.frame.origin.x, originOfCatsTable, self.catAndSubcatsTable.frame.size.width, self.catAndSubcatsTable.frame.size.height);
                     }
                     completion:^(BOOL finished){ }];

    [GlobalVariables getInstance].isUserSearchingOnSideBar = NO;
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.instagram.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2 , 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            self.instagram.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                self.instagram.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
           if ([AppName isEqualToString:@"Athènes"] && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pinterest]]) {
             
               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pinterest]];
           }
        else if(![AppName isEqualToString:@"Athènes"]  &&  [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:instagramSocial]])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:instagramSocial]];
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERREUR"
                                                            message:@"Ce réseau social n'a pas encore été installé"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];

        }
    });
}

- (IBAction)openTumblr:(id)sender {
    [self.searchArticles resignFirstResponder];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
     [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"PopUpNewsletterController"]];

}

- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (IBAction)openHomePage:(id)sender {
    if([self.searchArticles isFirstResponder]){
        [self.searchArticles resignFirstResponder];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [UIView animateWithDuration:0.2
                         animations:^{self.quickSearchView.alpha = 0.0;}
                         completion:^(BOOL finished){ self.quickSearchView.hidden = YES; }];
        [GlobalVariables getInstance].isUserSearchingOnSideBar = NO;
        [UIView animateWithDuration:0.3
                         animations:^{self.catAndSubcatsTable.frame = CGRectMake(self.catAndSubcatsTable.frame.origin.x, originOfCatsTable, self.catAndSubcatsTable.frame.size.width, self.catAndSubcatsTable.frame.size.height);
                         }
                         completion:^(BOOL finished){ }];

    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"ViewController"]];
        [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
    }
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [GlobalVariables getInstance].isUserSearchingOnSideBar = YES;
    
}


- (IBAction)seeAllResults:(id)sender {
    
    [self.searchArticles resignFirstResponder];
    [UIView animateWithDuration:0.2
                     animations:^{self.quickSearchView.alpha = 0.0;}
                     completion:^(BOOL finished){ self.quickSearchView.hidden = YES; }];
    [GlobalVariables getInstance].isUserSearchingOnSideBar = NO;
    [UIView animateWithDuration:0.3
                     animations:^{self.catAndSubcatsTable.frame = CGRectMake(self.catAndSubcatsTable.frame.origin.x, originOfCatsTable, self.catAndSubcatsTable.frame.size.width, self.catAndSubcatsTable.frame.size.height);
                     }
                     completion:^(BOOL finished){ }];

    
    [GlobalVariables getInstance].comingFromViewController = [GlobalVariables getInstance].currentViewController;
    [GlobalVariables getInstance].textSearched = self.searchArticles.text;
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"ListOfPostsController"]];
    
    
    
}

-(void)sendingAnHTTPPOSTRequestOniOSSearch: (NSString *)searchedText withPage: (NSString *)page{
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:adminAjax];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *params = [NSString stringWithFormat:@"action=dgab_search_posts&search=%@&page=%@",searchedText,page];
    
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
      NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
     
        
        filteredTableData = [[NSMutableArray alloc]init];

        NSUInteger pages = [[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"pages"]] integerValue];
        if(pages > 1){
            
            self.noArticlesFound.hidden = YES;
            
        for(int i = 0 ; i < 4; i++){
         //   NSLog(@"%@",[responseDict valueForKey:@"results"][i]);
            if([responseDict valueForKey:@"results"][i] != nil)
            [filteredTableData addObject:[responseDict valueForKey:@"results"][i]];
            
        }
        }
        else if ([[responseDict valueForKey:@"results"] count] == 4){
            [filteredTableData addObject:[responseDict valueForKey:@"results"][3]];
            [filteredTableData addObject:[responseDict valueForKey:@"results"][2]];
            [filteredTableData addObject:[responseDict valueForKey:@"results"][1]];
            [filteredTableData addObject:[responseDict valueForKey:@"results"][0]];
        }
        else if ([[responseDict valueForKey:@"results"] count] == 3){
            [filteredTableData addObject:[responseDict valueForKey:@"results"][2]];
            [filteredTableData addObject:[responseDict valueForKey:@"results"][1]];
            [filteredTableData addObject:[responseDict valueForKey:@"results"][0]];
        }
        else if ([[responseDict valueForKey:@"results"] count] == 2){
            [filteredTableData addObject:[responseDict valueForKey:@"results"][1]];
            [filteredTableData addObject:[responseDict valueForKey:@"results"][0]];
        }
        else if ([[responseDict valueForKey:@"results"] count] == 1){
            [filteredTableData addObject:[responseDict valueForKey:@"results"][0]];
        }
        else{
            filteredTableData = [[NSMutableArray alloc]init];
        }

        if(filteredTableData.count == 0)
            self.noArticlesFound.hidden = false;
        
        [self.resultsSearchTable reloadData];
        
        [searchSpinner endRefreshing];
        
    }];
    [dataTask resume];
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

-(void)searchArticle{
     self.noArticlesFound.hidden = YES;
    self.quickSearchView.alpha = 0.0f;
    [GlobalVariables getInstance].textSearched = self.searchArticles.text;
    
    [UIView animateWithDuration:0.3
                     animations:^{self.quickSearchView.alpha = 1.0f;
                         self.quickSearchView.hidden = false;}
                     completion:^(BOOL finished){ }];
    filteredTableData = [[NSMutableArray alloc] init];
    int x = 0;
    
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
        
        [self.resultsSearchTable reloadData];
        [searchSpinner beginRefreshing];
        self.noArticlesFound.hidden = true;
        [self sendingAnHTTPPOSTRequestOniOSSearch:[GlobalVariables getInstance].textSearched withPage:@"1"];
 
    }
    else{
        
        [GlobalVariables getInstance].DictionaryWithAllPosts = [[NSMutableDictionary alloc]initWithDictionary:(NSMutableDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[SimpleFilesCache cachedDataWithName:@"DictionaryWithAllPosts"]]];
        
        
        for( NSString *key in [[GlobalVariables getInstance].DictionaryWithAllPosts allKeys]){
            if(x < 4){
            
            if([self substring:[NSString stringWithFormat:@"%@",self.searchArticles.text] existsInString:[self stringByStrippingHTML:[self stringByDecodingXMLEntities:[NSString stringWithFormat:@"%@",[[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:key]valueForKey:@"post_title"]]]]] == YES){
                
                
                    [filteredTableData addObject:[[GlobalVariables getInstance].DictionaryWithAllPosts objectForKey:key]];
                
                x++;
             
                
            }
                
            }
        }
        [searchSpinner endRefreshing];
        
        
        if(filteredTableData.count == 0){
            self.noArticlesFound.hidden = NO;
        }
        
         [self.resultsSearchTable reloadData];
    }

    
}

-(BOOL)substring:(NSString *)substr existsInString:(NSString *)str {
    
    if(!([str rangeOfString:substr options:NSCaseInsensitiveSearch].length==0)) {
        return YES;
    }
    return NO;
}
- (IBAction)openCredits:(id)sender {

[kMainViewController hideLeftViewAnimated:NO completionHandler:nil];
[[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"CreditsViewController"]];
}
@end
