//
//  DistrictsViewController.m
//  VivreABerlin
//
//  Created by home on 17/05/2017.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#import "DistrictsViewController.h"
#import "GlobalVariables.h"
#import "FilterViewController.h"

@interface DistrictsViewController ()

@end

@implementation DistrictsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.districtsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.districtsIcon.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1 , 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.districtsIcon.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                self.districtsIcon.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
    
    self.districtsTable.backgroundColor = [self colorWithHexString:@"f1f2f5"];
    
    
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
    return [[[GlobalVariables getInstance].MapPageInfos valueForKey:@"districts"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    
//    const char *c = [cell.textLabel.text cStringUsingEncoding:NSISOLatin1StringEncoding];
//    cell.textLabel.text = [[NSString alloc]initWithCString:c encoding:NSUTF8StringEncoding];
    
    cell.textLabel.text = [self stringByStrippingHTML:[self stringByDecodingXMLEntities:[[[GlobalVariables getInstance].MapPageInfos valueForKey:@"districts"] valueForKey:@"name"][indexPath.row]]];
    cell.textLabel.text = [cell.textLabel.text stringByReplacingOccurrencesOfString:@"&ouml;" withString:@"ö"];
    
    if([[[[GlobalVariables getInstance].MapPageInfos valueForKey:@"districts"][indexPath.row] valueForKey:@"isSelected"] isEqualToString:@"YES"]){
        cell.imageView.image = [UIImage imageNamed:@"CheckBox.png"];
        cell.textLabel.font = [UIFont fontWithName:@"Montserrat-Light" size:17.f];
        cell.textLabel.textColor = [self colorWithHexString:@"41a9cc"];
        cell.backgroundColor = [self colorWithHexString:@"A5C6D3"];
    }
    else{
        cell.imageView.image = [UIImage imageNamed:@"uncheckBox.png"];
        cell.textLabel.font = [UIFont fontWithName:@"Montserrat-Light" size:16.f];
        cell.textLabel.textColor = [self colorWithHexString:@"303030"];
         cell.backgroundColor = [self colorWithHexString:@"f1f2f5"];
    }




    cell.textLabel.numberOfLines = 2;
    cell.textLabel.adjustsFontSizeToFitWidth = true;
    
    
    
    [self.districtsTable setSeparatorColor:[self colorWithHexString:@"D9D9D9"]];
    self.districtsTable.showsVerticalScrollIndicator = true;
    
   

    
    cell.imageView.transform = CGAffineTransformMakeScale(0.75, 0.75);
    
     [self.districtsTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    UITableViewCell *cell = [self.districtsTable cellForRowAtIndexPath:indexPath];
    
    cell.backgroundColor = [self colorWithHexString:@"A5C6D3"];
    
    
    cell.imageView.image = [UIImage imageNamed:@"CheckBox.png"];
    cell.textLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:14.f];
    cell.textLabel.textColor = [self colorWithHexString:@"41a9cc"];
    
    
    
    for (int i=0; i< [[[GlobalVariables getInstance].MapPageInfos valueForKey:@"districts"] count];i++){
        [[[GlobalVariables getInstance].MapPageInfos valueForKey:@"districts"][i] setValue:@"NO" forKey:@"isSelected"];
    }
    
    [[[GlobalVariables getInstance].MapPageInfos valueForKey:@"districts"][indexPath.row] setValue:@"YES" forKey:@"isSelected"];

    
    [GlobalVariables getInstance].latitudine = [[[[GlobalVariables getInstance].MapPageInfos  valueForKey:@"districts"] valueForKey:@"lat"][indexPath.row] floatValue];
    [GlobalVariables getInstance].longitudine = [[[[GlobalVariables getInstance].MapPageInfos  valueForKey:@"districts"] valueForKey:@"lng"][indexPath.row] floatValue];
    [GlobalVariables getInstance].zoomLvl = [[[[GlobalVariables getInstance].MapPageInfos  valueForKey:@"districts"] valueForKey:@"zoom"][indexPath.row] floatValue];
    
    [self.districtsTable reloadData];
    double delayInSeconds = 0.15;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFilters" object: [NSString stringWithFormat:@"filtrating"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFilters" object: [NSString stringWithFormat:@"reloadPozition"]];
        
    });
    
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (IBAction)openSideMenu:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object: [NSString stringWithFormat:@"menuButton"]];
}
- (IBAction)filtersButton:(id)sender {
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
 [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFilters" object: [NSString stringWithFormat:@"openFilters"]];
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

- (IBAction)closeDistricts:(id)sender {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFilters" object: [NSString stringWithFormat:@"reloadPozition"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFilters" object: [NSString stringWithFormat:@"filtrating"]];
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
