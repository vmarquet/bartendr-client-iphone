//
//  Commande.m
//  BarTendr
//
//  Created by ESIEA on 23/01/2015.
//  Copyright (c) 2015 Patouz. All rights reserved.
//

#import "Commande.h"

@implementation Commande

@synthesize total, liste_article, numberTable;

- (void) calculTotal {

    int i;
    
    for(i = 0; i<liste_article.count; i++){
        //remplir avec le prix de chaque article de la liste
        //total += liste_article[i][indexPrix];
    }
}

@end
