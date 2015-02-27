
//  BarTendr
//
//  Created by ESIEA on 27/01/2015.
//  Copyright (c) 2015 Patouz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecapCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nomBoisson;
@property (strong, nonatomic) IBOutlet UILabel *prixBoisson;
@property (weak, nonatomic) IBOutlet UIButton *suppression;

-(void) :(UITableView *)tableView3 buttonPressed2 :(NSIndexPath *)indexPath;
@end
