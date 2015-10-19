//
//  ChangeTypeController.h
//  SuZhouProject
//
//  Created by teddy on 15/10/9.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RootViewController.h"

typedef void(^ ChangeTypeBlock)(NSString * selecedType);
@interface ChangeTypeController : RootViewController

@property (nonatomic,strong) ChangeTypeBlock changBlock;

- (void)changeType:(ChangeTypeBlock)block;

@end
