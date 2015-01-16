//
//  Categorie.h
//  BarTendr
//
//  Created by Patouz on 16/01/2015.
//  Copyright (c) 2015 Patouz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categorie : NSObject {
    
    int id_categorie;
    NSString *nom_categorie;
    
}

@property (nonatomic) int id_categorie;
@property (nonatomic, retain) NSString *nom_categorie;

@end
