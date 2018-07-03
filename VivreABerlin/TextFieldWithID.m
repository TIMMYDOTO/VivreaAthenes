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
    return self;
}
@end
