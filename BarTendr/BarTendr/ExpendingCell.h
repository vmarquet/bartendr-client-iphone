//
//  ExpendingCell.h
//  BarTendr
//
//  Created by ESIEA on 16/01/2015.
//  Copyright (c) 2015 Patouz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpendingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageCell;
@property (strong, nonatomic) IBOutlet UILabel *titleCell;
@property (strong, nonatomic) IBOutlet UILabel *descCell;
@property (strong, nonatomic) IBOutlet UILabel *descLabelCell;
@property (strong, nonatomic) IBOutlet UILabel *priceLabelCell;
@property (strong, nonatomic) IBOutlet UIButton *addButton;

- (IBAction)buttonTapped:(UIButton *)sender;

@end
