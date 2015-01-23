//
//  Commande.h
//  BarTendr
//
//  Created by ESIEA on 23/01/2015.
//  Copyright (c) 2015 Patouz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commande : NSObject {
    
    NSMutableArray * liste_article;
    unsigned int total;
    //Date
    int numberTable;
}

@property (nonatomic) unsigned int total;
@property (strong, nonatomic) NSMutableArray * liste_article;
@property (nonatomic) int numberTable;

@end
