//
//  HDConnectModel.h
//  IOSChat
//
//  Created by Li Shijie on 13-7-8.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pomelo.h"

//typedef void(^PomeloCallback) (id callback);

@interface HDConnectModel : NSObject<PomeloDelegate,UIAlertViewDelegate>
+(HDConnectModel *)sharedConnect;
-(void)reConnect;
-(void)disreconect;
//-(void)abc;
@property(strong,nonatomic)NSMutableArray *contactList;
-(void)sendContent:(NSString *)aContent
        WithTarget:(NSString *)aTarget
 WithCompleteBlock:(PomeloCallback)callback;
-(void)sendContentAlert:(NSString *)aContent
             WithTarget:(NSString *)aTarget
      WithCompleteBlock:(PomeloCallback)callback;
@end
