//
//  HDDeclare.h
//  HDNHMuseum
//
//  Created by Li Shijie on 13-7-31.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HDDeclare : NSObject
{}
@property(strong,nonatomic)NSString *userName;
@property(strong,nonatomic)NSString *nickName;
@property(strong,nonatomic)NSString *userID;
@property(strong,nonatomic)NSString *channel;
@property(nonatomic)BOOL autoFlag;
@property(strong,nonatomic)NSString *language;
@property(strong,nonatomic)NSString *unit;
@property(strong,nonatomic)NSString *alertTitle;
@property(strong,nonatomic)NSString *alertCancel;
@property(strong,nonatomic)NSString *alertOK;
@property(strong,nonatomic)NSString *InvalidInput;

@property(strong,nonatomic)NSString *netServerAddress;
@property(nonatomic)NSInteger netGatePort;
@property(nonatomic)NSInteger netConnectPort;
@property(strong,nonatomic)NSString *LANServerAddress;
@property(nonatomic)NSInteger LANGatePort;
@property(nonatomic)NSInteger LANConnectPort;
@property(strong,nonatomic)NSString *netDownloadAddress;
@property(strong,nonatomic)NSString *LANDownloadAddress;
@property(strong,nonatomic)NSString *LANSSID;

@property(strong,nonatomic)NSString *serverAddress;
@property(nonatomic)NSInteger gatePort;
@property(nonatomic)NSInteger connectPort;
@property(strong,nonatomic)NSString *downloadAddress;

@property(strong,nonatomic)NSString *downloading;
@property(strong,nonatomic)NSString *instralling;
@property(strong,nonatomic)NSString *downloadFailed;

@property(strong,nonatomic)NSString *target;
@property(strong,nonatomic)NSString *groupNumber;
@property(strong,nonatomic)NSString *appVersion;
@property(strong,nonatomic)NSString *dataBaeVersion;
@property(nonatomic) BOOL netStatus;

@property(nonatomic,strong)NSString *education;
@property(nonatomic,strong)NSString *SOS;
@property(nonatomic,strong)NSString *SOSSuceed;
@property(nonatomic,strong)NSString *Interaction;
@property(nonatomic,strong)NSString *Questionnaire;
@property(nonatomic,strong)NSString *Feedback;
@property(nonatomic,strong)NSString *outsideService;
@property(nonatomic,strong)NSString *noMessage;
@property(nonatomic,strong)NSString *map;
@property(nonatomic,strong)NSString *strategy;
@property(nonatomic,strong)NSString *visit;
@property(nonatomic,strong)NSString *traffic;
@property(nonatomic,strong)NSString *arrive;
@property(nonatomic,strong)NSString *museumInfo;
@property(nonatomic,strong)NSString *website;
@property(nonatomic,strong)NSString *myFriend;
@property(nonatomic,strong)NSString *joinGroup;
@property(nonatomic,strong)NSString *joinNumberNeed;
@property(nonatomic,strong)NSString *joinFailed;
@property(nonatomic,strong)NSString *registerGroup;
@property(nonatomic,strong)NSString *registerFailed;
@property(nonatomic,strong)NSString *registerSucceed;
@property(nonatomic,strong)NSString *outsideGroup;
@property(nonatomic,strong)NSString *noLocationInfo;
@property(nonatomic,strong)NSString *introduce;
@property(nonatomic,strong)NSString *information;
@property(nonatomic,strong)NSString *AutoNavigation;
@property(nonatomic,strong)NSString *settingLanguage;
@property(nonatomic,strong)NSString *autoLocation;
@property(nonatomic,strong)NSString *setting;
@property(nonatomic,strong)NSString *Panoramic;
@property(nonatomic,strong)NSString *NewVersions;
@property(nonatomic,strong)NSString *NewDatabase;
@property(nonatomic,strong)NSString *detail;
@property(nonatomic,strong)NSString *myinformation;
@property(nonatomic,strong)NSString *thenews;
@property(nonatomic,strong)NSString *yourOutside;
@property(nonatomic,strong)NSString *yourInside;
@property(nonatomic,strong)NSString *nameLabel;
@property(nonatomic,strong)NSString *groupLabel;
@property(nonatomic,strong)NSString *input;
@property(nonatomic,strong)NSString *nullcontent;
@property(nonatomic,strong)NSString *feedbacksuceed;



+(id)sharedDeclare;
-(NSString *)applicationLibraryDirectory;
-(NSURL *)applicationLibraryURLDirectory;
- (NSString *)fetchSSIDInfo;
-(void)upadteDataVersion:(NSString *)aVersion;
@end
