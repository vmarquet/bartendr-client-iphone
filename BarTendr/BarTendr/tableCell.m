//
//  tableCell.m
//  BarTendr
//
//  Created by ESIEA on 09/01/2015.
//  Copyright (c) 2015 Patouz. All rights reserved.
//

#import "tableCell.h"

@implementation SimpleTableCell
@synthesize nameLabel = _nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end