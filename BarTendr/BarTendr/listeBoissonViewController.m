//
//  listeBoissonViewController.m
//  BarTendr
//
//  Created by ESIEA on 28/11/2014.
//  Copyright (c) 2014 Patouz. All rights reserved.
//

#import "listeBoissonViewController.h"

@interface listeBoissonViewController ()

@end

@implementation listeBoissonViewController
@synthesize data2;
@synthesize labelTitre;
@synthesize boissonType;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    labelTitre.text = boissonType;
    NSLog(@"boissonType = %@", boissonType);
    
    // Initialisation de la TableView
    data2 = [[NSMutableArray alloc]initWithObjects:@"Heineken", @"Kronenbourg", @"Grimbergen", @"Leffe Blonde", @"Leffe Ruby", @"Kilkenny", @"Guiness", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)section2 {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView2 numberOfRowsInSection:(NSInteger)section2 {
    return [data2 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath2 {
    
    static NSString *CellIdentifier2 = @"Cell2";
    UITableViewCell *cell2 = [tableView2 dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath2];
    
    if(cell2 == nil){
        cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
    }
    
    cell2.textLabel.text = [data2 objectAtIndex:indexPath2.row];
    return cell2;
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
