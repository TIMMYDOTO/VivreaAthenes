//
//  FilterViewController.m
//  VivreABerlin
//
//  Created by home on 17/05/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "FilterViewController.h"
#import "GlobalVariables.h"
#import "FilterCell.h"
#import "SubFilterCell.h"
#import "DistrictsViewController.h"
#import "UIImageView+Network.h"
#import "Reachability.h"
#import "SimpleFilesCache.h"
@interface FilterViewController ()

@end

@implementation FilterViewController
{
    
    __weak IBOutlet UIButton *checkAll;
    JTMaterialSpinner *globalSpinner;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [UIView animateWithDuration:0.1 animations:^{
        self.filtersIcon.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1 , 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.filtersIcon.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                self.filtersIcon.transform = CGAffineTransformIdentity;
            }];
        }];
    }];

    [GlobalVariables getInstance].arrayWithAnnotations = [[NSMutableArray alloc]initWithArray:[[GlobalVariables getInstance].MapPageInfos valueForKey:@"categories"]];
    
    
    for ( int i = 0 ; i < [GlobalVariables getInstance].arrayWithAnnotations.count;i++){
        [[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:i] setValue:@"NO" forKey:@"isExpanded"];
        
        [[GlobalVariables getInstance].arrayWithAnnotations setValue:@"0" forKey:@"level"];
        for ( int j = 0 ; j < [[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"subcategories"] count]; j ++){
            
            [[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"subcategories"][j] setValue:@"1" forKey:@"level"];
            
        }
    }
    if(([GlobalVariables getInstance].PerSessionForFilters != true) ){
        for ( int i = 0 ; i < [[GlobalVariables getInstance].arrayWithAnnotations count];i++){
            for ( int j = 0 ; j < [[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"subcategories"] count]; j ++) {
                [[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"subcategories"][j] setValue:@"YES" forKey:@"isSelected"];
                
            }
        }
        [GlobalVariables getInstance].PerSessionForFilters = true;
    }

    
    
    self.filterTable.backgroundColor = [self colorWithHexString:@"f1f2f5"];
    int number = 0;
    int contor = 0;
    for (int k = 0 ;k < [[[GlobalVariables getInstance].MapPageInfos valueForKey:@"categories"] count]; k++)
        for(int i = 0 ; i< [[[GlobalVariables getInstance].arrayWithAnnotations[k] valueForKey:@"subcategories"] count];i++){
            if([[[[GlobalVariables getInstance].arrayWithAnnotations[k] valueForKey:@"subcategories"][i] valueForKey:@"isSelected"] isEqualToString:@"YES"])
                contor ++;
            
            number ++;
        }
    if (contor == number){
        
        
        self.checkAllText.text = @"TOUT DÉCOCHER";
        self.checkAllImage.image = [UIImage imageNamed:@"CheckBox.png"];
        
    }
    else {
        self.checkAllText.text = @"TOUT COCHER";
        self.checkAllImage.image = [UIImage imageNamed:@"uncheckBox.png"];
    }
    
    
    globalSpinner = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.center.x - 22, self.view.center.y - 45, 45, 45)];
    globalSpinner.circleLayer.lineWidth = 3.0;
    globalSpinner.circleLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    
    
    
    [self.view addSubview: globalSpinner];
    [self.view bringSubviewToFront: globalSpinner];
    

    
    self.view.backgroundColor = [self colorWithHexString:@"f1f2f5"];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[GlobalVariables getInstance].arrayWithAnnotations count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FilterCell";
    
    FilterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    cell.indentationWidth = 15;
    [cell setIndentationLevel:[[[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
    
    
    
    
    if (cell.indentationLevel == 0) {
        
        cell.titletext.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:indexPath.row] valueForKey:@"category_name"]]];
        cell.titletext.font = [UIFont fontWithName:@"Montserrat-Light" size:14.f];
        cell.titletext.textColor = [self colorWithHexString:@"303030"];
        
        
        
        cell.titletext.adjustsFontSizeToFitWidth = true;
        cell.box.image = [UIImage imageNamed:@"uncheckBox.png"];
        
        cell.expandArrow.hidden = false;
        
        cell.titletext.numberOfLines = 2;
        cell.titletext.adjustsFontSizeToFitWidth = true;
        
        cell.expandArrow.image = [UIImage imageNamed:@"expandArrow.png"];
        if ([[[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:indexPath.row] valueForKey:@"isExpanded"] isEqualToString:@"YES"]){
            cell.expandArrow.image = [UIImage imageNamed:@"closeFitlers.png"];
        }
        
        
        
        int contor = 0;
        for(int i = 0 ; i< [[[GlobalVariables getInstance].arrayWithAnnotations[indexPath.row] valueForKey:@"subcategories"] count];i++){
            if([[[[GlobalVariables getInstance].arrayWithAnnotations[indexPath.row] valueForKey:@"subcategories"][i] valueForKey:@"isSelected"] isEqualToString:@"YES"])
                contor ++;
        }
        if (contor == [[[GlobalVariables getInstance].arrayWithAnnotations[indexPath.row] valueForKey:@"subcategories"] count]){
            
            cell.box.image = [UIImage imageNamed:@"CheckBox.png"];
            
            
            cell.titletext.textColor = [self colorWithHexString:@"41a9cc"];
            cell.expandArrow.image = [UIImage imageNamed:@"expandArrowColored.png"];
            
            if ([[[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:indexPath.row] valueForKey:@"isExpanded"] isEqualToString:@"YES"]){
                cell.expandArrow.image = [UIImage imageNamed:@"closeFiltersColored.png"];
            }
            
        }
        else if ( contor > 0 && contor < [[[GlobalVariables getInstance].arrayWithAnnotations[indexPath.row] valueForKey:@"subcategories"] count]){
            
            cell.titletext.textColor = [self colorWithHexString:@"303030"];
            cell.box.image = [UIImage imageNamed:@"incompleteBox.png"];
        }
        
        
        
        cell.titletext.font = [UIFont fontWithName:@"Montserrat-Light" size:17.f];
        
        
        [cell.expandAllButton addTarget:self
                                 action:@selector(CheckALL:)
                       forControlEvents:UIControlEventTouchUpInside];
        
        cell.expandAllButton.tag = indexPath.row;
        cell.expandAllButton.backgroundColor = [UIColor clearColor];
        
        
        
        
    }
    else if (cell.indentationLevel == 1){
        
        static NSString *CellIdentifier = @"SubFilterCell";
        
        SubFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.subTitleText.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:indexPath.row] valueForKey:@"category_name"]]];
        
        NSLog(@"cell.subTitleText.tex %@",  cell.subTitleText.text);
        cell.subTitleText.font = [UIFont fontWithName:@"Montserrat-Light" size:15.f];
        cell.subTitleText.textColor = [self colorWithHexString:@"303030"];

        
        
        
        
        if([[[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:indexPath.row] valueForKey:@"isSelected"] isEqualToString:@"YES"]){
            cell.subBox.image = [UIImage imageNamed:@"CheckBox.png"];
            cell.subTitleText.font = [UIFont fontWithName:@"Montserrat-Light" size:15.f];
            cell.subTitleText.textColor = [self colorWithHexString:@"41a9cc"];
        }
        else {
            
            cell.subBox.image = [UIImage imageNamed:@"uncheckBox.png"];
            
            
        }
        
        
        cell.subTitleText.adjustsFontSizeToFitWidth = true;
        
        cell.subBox.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        NSLog(@"url %@", [NSURL URLWithString: [[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:indexPath.row] valueForKey:@"icon_url"]]);
        
        [cell.subCategorieImg loadImageFromURL: [NSURL URLWithString: [[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:indexPath.row] valueForKey:@"icon_url"]]
                              placeholderImage: nil
                                    cachingKey: [NSString stringWithFormat:@"%@",[[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:indexPath.row] valueForKey:@"category_id"]]];
        
//        NSLog(@"image: %@", cell.subCategorieImg.image);
//        if([self isInternet] == NO)
//        {
//            cell.subCategorieImg.image = nil;
//        }
        
        cell.subCategorieImg.contentMode = UIViewContentModeScaleAspectFit;
        cell.subCategorieImg.clipsToBounds = true;
        
        cell.subTitleText.numberOfLines = 2;
        
        
        
        
        //cell.expandAllButton.userInteractionEnabled = false;
        
        
        cell.backgroundColor = [self colorWithHexString:@"f1f2f5"];
        return cell;
    }
    
    
    
    
    cell.backgroundColor = [self colorWithHexString:@"f1f2f5"];
    return cell;
}

- (void) CheckALL: (UIButton*) button {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSInteger tag = button.tag;
        
     //   NSLog(@"%ld",(long)tag);
        [GlobalVariables getInstance].canFilter = true;
        
        int contor = 0;
        
        for(int i = 0 ; i< [[[GlobalVariables getInstance].arrayWithAnnotations[tag] valueForKey:@"subcategories"] count];i++){
            if([[[[GlobalVariables getInstance].arrayWithAnnotations[tag] valueForKey:@"subcategories"][i] valueForKey:@"isSelected"] isEqualToString:@"YES"])
                contor ++;
        }
        if (contor == [[[GlobalVariables getInstance].arrayWithAnnotations[tag] valueForKey:@"subcategories"] count]){
            
            for(int i = 0 ; i< [[[GlobalVariables getInstance].arrayWithAnnotations[tag] valueForKey:@"subcategories"] count];i++){
                [[[GlobalVariables getInstance].arrayWithAnnotations[tag] valueForKey:@"subcategories"][i] setValue:@"NO" forKey:@"isSelected"];
            }
            
        }
        else {
            
            for(int i = 0 ; i< [[[GlobalVariables getInstance].arrayWithAnnotations[tag] valueForKey:@"subcategories"] count];i++){
                [[[GlobalVariables getInstance].arrayWithAnnotations[tag] valueForKey:@"subcategories"][i] setValue:@"YES" forKey:@"isSelected"];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            

            [self.filterTable reloadData];
            
        });
        
        
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    NSDictionary *d=[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:indexPath.row];
    if([d valueForKey:@"subcategories"]) {
        NSArray *ar=[d valueForKey:@"subcategories"];
        
        BOOL isAlreadyInserted=NO;
        
        for(NSDictionary *dInner in ar ){
            NSInteger index=[[GlobalVariables getInstance].arrayWithAnnotations indexOfObjectIdenticalTo:dInner];
            isAlreadyInserted=(index>0 && index!=NSIntegerMax);
            if(isAlreadyInserted) break;
            
            
        }
        if(ar.count == 0){
            
            
        }
        if(isAlreadyInserted) {
            [[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:indexPath.row] setValue:@"NO" forKey:@"isExpanded"];
            [self miniMizeThisRows:ar];
        } else {
            
            
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arCells=[NSMutableArray array];
            for(NSDictionary *dInner in ar ) {
                [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [[GlobalVariables getInstance].arrayWithAnnotations insertObject:dInner atIndex:count++];
            }
            
            [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
            
            [self.filterTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:indexPath.row] setValue:@"YES" forKey:@"isExpanded"];
            [self.filterTable reloadData];
        }
        
    }
    else {
      //  NSLog(@"This Cell doesn't have any other children %@",[d valueForKey:@"category_name"]);
        if([[[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:indexPath.row] valueForKey:@"isSelected"] isEqualToString:@"YES"])
            [[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:indexPath.row] setValue:@"NO" forKey:@"isSelected"];
        else
            [[[GlobalVariables getInstance].arrayWithAnnotations objectAtIndex:indexPath.row] setValue:@"YES" forKey:@"isSelected"];
        
        [GlobalVariables getInstance].canFilter = true;
        [self.filterTable reloadData];
        
    }
    
}

-(void)miniMizeThisRows:(NSArray*)ar{
    
    for(NSDictionary *dInner in ar ) {
        NSUInteger indexToRemove=[[GlobalVariables getInstance].arrayWithAnnotations indexOfObjectIdenticalTo:dInner];
        NSArray *arInner=[dInner valueForKey:@"subcategories"];
        if(arInner && [arInner count]>0){
            [self miniMizeThisRows:arInner];
        }
        
        if([[GlobalVariables getInstance].arrayWithAnnotations indexOfObjectIdenticalTo:dInner]!=NSNotFound) {
            [[GlobalVariables getInstance].arrayWithAnnotations removeObjectIdenticalTo:dInner];
            [self.filterTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                      [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                      ]
                                    withRowAnimation:UITableViewRowAnimationRight];
        }
    }
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.filterTable reloadData];
        
    });
    
}



- (IBAction)openSideMenu:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"menuButton"]];
}

- (IBAction)openDistricts:(id)sender {
    
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFilters" object: [NSString stringWithFormat:@"openDistricts"]];
    
    
    
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



- (IBAction)CheckAll:(id)sender {
    [GlobalVariables getInstance].canFilter = true;
    
    self.view.userInteractionEnabled = false;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.checkAllImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1 , 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.checkAllImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                self.checkAllImage.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
    
    
    if ([self.checkAllText.text isEqualToString:@"TOUT COCHER"]){
        self.checkAllText.text = @"TOUT DÉCOCHER";
        self.checkAllImage.image = [UIImage imageNamed:@"CheckBox.png"];
        for ( int i = 0 ; i < [GlobalVariables getInstance].arrayWithAnnotations.count;i++){
            for ( int j = 0 ; j < [[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"subcategories"] count]; j ++) {
                [[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"subcategories"] setValue:@"YES" forKey:@"isSelected"];
                
            }
        }
    }
    else {
        self.checkAllText.text = @"TOUT COCHER";
        self.checkAllImage.image = [UIImage imageNamed:@"uncheckBox.png"];
        for ( int i = 0 ; i < [GlobalVariables getInstance].arrayWithAnnotations.count;i++){
            for ( int j = 0 ; j < [[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"subcategories"] count]; j ++) {
                [[[GlobalVariables getInstance].arrayWithAnnotations[i] valueForKey:@"subcategories"] setValue:@"NO" forKey:@"isSelected"];
                
            }
        }
        
    }
    self.view.userInteractionEnabled = true;
    //  dispatch_async(dispatch_get_main_queue(), ^{
    [self.filterTable reloadData];
    //  });
    
    
    //  });}
}
- (IBAction)backToMap:(id)sender {
    
    
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFilters" object: [NSString stringWithFormat:@"filtrating"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFilters" object: [NSString stringWithFormat:@"reloadPozition"]];
   
}

- (IBAction)closeFilters:(id)sender {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFilters" object: [NSString stringWithFormat:@"reloadPozition"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFilters" object: [NSString stringWithFormat:@"filtrating"]];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFilters" object: [NSString stringWithFormat:@"reloadPozition"]];
}
-(BOOL)isInternet{
    
    
    if(!([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable))
    {
    //    NSLog(@"User has internet");
        return YES;
        
    }
    
    else {
    //    NSLog(@"User doesn't have internet");
        
        return NO;
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
                
              //  NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
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
//-(void)viewDidDisappear:(BOOL)animated{
//    [SimpleFilesCache saveToCacheDirectory:[NSKeyedArchiver archivedDataWithRootObject:[GlobalVariables getInstance].arrayWithAnnotations] withName:@"ArrayWithAnnotationsSaved"];
//}
@end
