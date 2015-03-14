//
//  ExpendingCell.m
//  BarTendr
//
//  Created by ESIEA on 16/01/2015.
//  Copyright (c) 2015 Patouz. All rights reserved.
//

#import "ExpendingCell.h"
#import "Globals.h"



@implementation ExpendingCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)buttonPressed {
    NSLog(@"Button Pressed!");
}

- (void)buttonTapped:(id)sender
{
    NSLog(@"Button Tapped!");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    commentaire = self.commentTextField.text;
    if(commentaire.length > 255 || commentaire.length == 0)
    {
        commentaire = nil;
    }
    [textField resignFirstResponder];
    return YES;
}

@end
