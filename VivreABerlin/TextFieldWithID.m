//
//  TextFieldWithID.m
//  VivreABerlin
//
//  Created by Artyom Schiopu on 6/15/18.
//  Copyright © 2018 Stoica Mihail. All rights reserved.
//

#import "TextFieldWithID.h"

@implementation TextFieldWithID

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [self  setFont: [UIFont fontWithName:@"Gudea" size:25]];
    
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setLeftView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)]];
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    return self;
}
@end
