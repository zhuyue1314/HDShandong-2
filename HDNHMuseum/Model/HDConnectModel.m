//
//  HDConnectModel.m
//  IOSChat
//
//  Created by Li Shijie on 13-7-8.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDConnectModel.h"
#import "HDDeclare.h"
#import "HDBroadcast.h"
#import "HDBroadcastViewController.h"
#import "HDAppDelegate.h"
@interface HDConnectModel()
-(void)initConnect;
- (void)entryWithData:(NSDictionary *)data;
-(void)updateContactList;
- (void)receiveContent;
@property(strong,nonatomic)Pomelo *pomelo;
@property(strong,nonatomic)NSString *name;
@property(strong,nonatomic)NSString *channel;
@property(strong,nonatomic)NSMutableArray *receiveAD;
@end
static HDDeclare *declare;
@implementation HDConnectModel
+(HDConnectModel *)sharedConnect
{
    static HDConnectModel *sharedConnect;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConnect = [[self alloc] init];
    });
    
    return sharedConnect;

}
-(id)init
{
    self = [super init];
    if (self)
    {
        [self initConnect];
    }
    return self;
}

-(void)reConnect
{
    self.name = declare.userName;
    self.channel = declare.channel;
    if([[declare fetchSSIDInfo]isEqualToString:declare.LANSSID])
    {
        declare.serverAddress = declare.LANServerAddress;
        declare.gatePort = declare.LANGatePort;
    }
    else
    {
        declare.serverAddress = declare.netServerAddress;
        declare.gatePort = declare.netGatePort;
    }

    [self.pomelo connectToHost:declare.serverAddress
                        onPort:declare.gatePort
                  withCallback:^(Pomelo *p){
                      NSDictionary *params = nil;
                      if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"pomelo"] isEqualToString:@"NO"])
                      {
                          [[NSUserDefaults standardUserDefaults]setObject:@"OK" forKey:@"pomelo"];
                          params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.name,@"register", nil] forKeys:[NSArray arrayWithObjects:@"uid",@"fangshi",nil]];
                      }
                      else
                      {
                          
                          params = [NSDictionary dictionaryWithObject:self.name forKey:@"uid"];
                      }
                      NSLog(@"params%@",params);
                      [self.pomelo requestWithRoute:@"gate.gateHandler.queryEntry"
                                          andParams:params
                                        andCallback:^(NSDictionary *result){
                                            [self.pomelo disconnectWithCallback:^(Pomelo *p){
                                                [self entryWithData:result];
                                            }];
                                        }];
                  }];
}
-(void)initConnect
{
    declare = [HDDeclare sharedDeclare];
    self.receiveAD = [NSMutableArray arrayWithCapacity:0];
    self.pomelo = [[Pomelo alloc]initWithDelegate:self];
    self.contactList = [[NSMutableArray alloc]initWithCapacity:1];
    [self.contactList addObject:@"All"];
    self.name = declare.userName;
    self.channel = declare.channel;
    if([[declare fetchSSIDInfo]isEqualToString:declare.LANSSID])
    {
        declare.serverAddress = declare.LANServerAddress;
        declare.gatePort = declare.LANGatePort;
    }
    else
    {
        declare.serverAddress = declare.netServerAddress;
        declare.gatePort = declare.netGatePort;
    }
    [self.pomelo connectToHost:declare.serverAddress
                        onPort:declare.gatePort
                  withCallback:^(Pomelo *p){
        NSDictionary *params = params = [NSDictionary dictionaryWithObject:self.name forKey:@"uid"];
        [self.pomelo requestWithRoute:@"gate.gateHandler.queryEntry"
                            andParams:params
                          andCallback:^(NSDictionary *result){
            [self.pomelo disconnectWithCallback:^(Pomelo *p){
                [self entryWithData:result];
            }];
        }];
    }];
}
-(void)disreconect
{
    [self.pomelo disconnect];
    [self reConnect];
}
- (void)entryWithData:(NSDictionary *)data
{
    NSLog(@"%@",[data objectForKey:@"code"]);
    if ([[data objectForKey:@"code"]intValue]==501||[[data objectForKey:@"code"]intValue]==502)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"pomelo"];
        [self reConnect];
        
        return;
    }
    if ([[data objectForKey:@"code"]intValue]==200)
    {
        if([[declare fetchSSIDInfo]isEqualToString:declare.LANSSID])
        {
            declare.serverAddress = [data objectForKey:@"host"];
            declare.connectPort = [[data objectForKey:@"port"] intValue];
        }
        else
        {
            declare.serverAddress = declare.netServerAddress;
            declare.connectPort = declare.netConnectPort;
        }
        NSLog(@"data%@",data);
        [self.pomelo connectToHost:declare.serverAddress
                            onPort:declare.connectPort
                      withCallback:^(Pomelo *p){
                          
                          NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  self.name, @"username",
                                                  self.channel, @"rid",
                                                  nil];
                          
                          NSLog(@"cnneect%@",params);
                          [p requestWithRoute:@"connector.entryHandler.enter"
                                    andParams:params
                                  andCallback:^(NSDictionary *result)
                           {
                               NSArray *userList = [result objectForKey:@"users"];
                               [self.contactList addObjectsFromArray:userList];
                               [self.contactList removeObject:self.name];
                               
                               [self updateContactList];
                               [self receiveContent];
                               
                               [[NSNotificationCenter defaultCenter] addObserver:self
                                                                        selector:@selector(autoDemand:)
                                                                            name:@"RFID"
                                                                          object:nil];
                               
                           }];
                      }];

    }
    else
        return;
}
-(void)autoDemand:(NSNotification*)notification
{
    NSDictionary *dic = [notification userInfo];
    NSString *number = [dic objectForKey:@"content"];
    //weizi机器号#RFID#电量#
    NSString *content = [NSString stringWithFormat:@"weizi%@#%@#100#",declare.userName,number];
    [self sendContent:content
           WithTarget:declare.channel
    WithCompleteBlock:^(NSDictionary *re){
        NSLog(@"RFID%@",re);
    }];
}

-(void)updateContactList
{
    
    [self.pomelo onRoute:@"onAdd"
            withCallback:^(NSDictionary *data){
//        NSLog(@"user add -----");
//        NSString *addName = [data objectForKey:@"user"];
//        [self.contactList addObject:addName];
    }];
    [self.pomelo onRoute:@"onLeave"
            withCallback:^(NSDictionary *data){
//        NSLog(@"user leave ----");
//        NSString *leaveName = [data objectForKey:@"user"];
//        if ([self.contactList containsObject:leaveName]) {
//            NSUInteger index = [self.contactList indexOfObject:leaveName];
//            [self.contactList removeObjectAtIndex:index];
//        }
    }];
}
-(void)sendContent:(NSString *)aContent
        WithTarget:(NSString *)aTarget
 WithCompleteBlock:(PomeloCallback)callback
{
    if (declare.netStatus)
    {
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              aContent, @"content",
                              aTarget, @"target",
                              nil];
        
        if ([aTarget isEqualToString:@"*"]) {
            [self.pomelo notifyWithRoute:@"chat.chatHandler.send"
                               andParams:data];
        } else {
            [self.pomelo requestWithRoute:@"chat.chatHandler.send"
                                andParams:data
                              andCallback:callback];
        }
    }
}
-(void)sendContentAlert:(NSString *)aContent
        WithTarget:(NSString *)aTarget
 WithCompleteBlock:(PomeloCallback)callback
{
    if (declare.netStatus)
    {
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              aContent, @"content",
                              aTarget, @"target",
                              nil];
        
        if ([aTarget isEqualToString:@"*"]) {
            [self.pomelo notifyWithRoute:@"chat.chatHandler.send"
                               andParams:data];
        } else {
            [self.pomelo requestWithRoute:@"chat.chatHandler.send"
                                andParams:data
                              andCallback:callback];
        }
    }
    else
    {
       UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:declare.alertTitle
                                                      message:declare.downloadFailed
                                                     delegate:nil
                                            cancelButtonTitle:declare.alertOK
                                            otherButtonTitles:nil, nil];
       [alert show];
    }

}

-(void)alert:(NSDictionary *)data withTag:(NSInteger)tag
{
    NSString *content = [data objectForKey:@"content"];
    NSString *cancle = [data objectForKey:@"cancel"];
    NSString *ok = [data objectForKey:@"ok"];
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    if (tag == 0)
    {
        dispatch_async(mainQueue, ^(void) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:nil cancelButtonTitle:cancle otherButtonTitles:nil, nil];
            [alert show];
            
            
        });
    }
    else
    {
        dispatch_async(mainQueue, ^(void) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:cancle otherButtonTitles:ok, nil];
            alert.tag = tag;
            [alert show];
            
            
        });
    }
}

- (void)receiveContent
{
    [self.pomelo onRoute:@"onChat"
            withCallback:^(NSDictionary *data){
        NSLog(@"receiveContentonChat------%@",[data objectForKey:@"body"]);
                
                NSString *path = [NSString stringWithFormat:@"%@/receive.plist",[[HDDeclare sharedDeclare]applicationLibraryDirectory]];
                
                NSMutableData *datat = [[NSMutableData alloc]
                                       initWithContentsOfFile:path];
                NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                                 initForReadingWithData:datat];
                [self.receiveAD removeAllObjects];
                [self.receiveAD addObjectsFromArray:
                 [unarchiver decodeObjectForKey:@"receiveAD"]];
                [unarchiver finishDecoding];

                NSDictionary *dic = [data objectForKey:@"body"];
                NSString *string = [dic objectForKey:@"msg"];
                
                NSArray *array = [string componentsSeparatedByString:@"#"];
                HDBroadcast *item = [[HDBroadcast alloc]init];
                [item initWithArray:array];
            
                [self.receiveAD insertObject:item atIndex:0];
                NSMutableData *receiveData = [[NSMutableData alloc] init];
                NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                             initForWritingWithMutableData:receiveData];
                
                [archiver encodeObject:self.receiveAD forKey:@"receiveAD"];
                [archiver finishEncoding];
                
                if ([receiveData writeToFile: path atomically: YES])
                {
                    NSLog(@"fhjdskfhskafhlas");
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:@"news" object:nil];
                NSDictionary *alertDic =[NSDictionary dictionaryWithObjectsAndKeys:item.title,@"content",@"忽略",@"cancel",@"查看",@"ok" ,nil];
                [self alert:alertDic withTag:101];
        
                
    }];
}
//-(void)abc
//{
//    HDBroadcast *item = [[HDBroadcast alloc]init];
//    
//    item.title = @"系统通知2";
//    item.identifier = @"default1";
//    item.content = @"您好！欢迎使用山东美术馆智慧服务系统！";
//    item.status = @"new";
//    item.time = @"0";
//    NSString *path = [NSString stringWithFormat:@"%@/receive.plist",[declare applicationLibraryDirectory]];
//    
//    NSMutableData *datat = [[NSMutableData alloc]
//                            initWithContentsOfFile:path];
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
//                                     initForReadingWithData:datat];
//    [self.receiveAD removeAllObjects];
//    [self.receiveAD addObjectsFromArray:
//     [unarchiver decodeObjectForKey:@"receiveAD"]];
//    [unarchiver finishDecoding];
//    
//    [self.receiveAD insertObject:item atIndex:0];
//    
//    
//    
//    NSMutableData *receiveData = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
//                                 initForWritingWithMutableData:receiveData];
//    
//    [archiver encodeObject:self.receiveAD forKey:@"receiveAD"];
//    [archiver finishEncoding];
//    
//    if ([receiveData writeToFile: path atomically: YES])
//    {
//        NSLog(@"fhjdskfhskafhlas");
//    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"news" object:nil];
//    NSDictionary *alertDic =[NSDictionary dictionaryWithObjectsAndKeys:item.title,@"content",@"忽略",@"cancel",@"查看",@"ok" ,nil];
//    [self alert:alertDic withTag:101];
//}
-(void)PomeloDidConnect:(Pomelo *)pomelo
{
    NSLog(@"PomeloDidConnect!!!!!!!!!");
    declare.netStatus = YES;
}
- (void)PomeloDidDisconnect:(Pomelo *)pomelo withError:(NSError *)error
{
    NSLog(@"PomeloDidDisconnectcode:%d",[error code]);
    NSInteger code = [error code];
    if (code==SocketIOServerRespondedWithDisconnect)
    {
        return;
    }
    else if (code == 57)
    {
        declare.netStatus = NO;
        [self reConnect];
//        NSDictionary *alertDic =[NSDictionary dictionaryWithObjectsAndKeys:@"您的网络连接出现异常,请检查网络设置",@"content",@"确定",@"cancel",@"确定",@"ok" ,nil];
//        [self alert:alertDic withTag:0];
    }
}
-(void)PomeloFailed:(Pomelo *)pomelo withError:(NSError *)error
{
    if ([error code]==SocketIOHandshakeFailed)
    {
        declare.netStatus = NO;
        [self reConnect];
//        NSDictionary *alertDic =[NSDictionary dictionaryWithObjectsAndKeys:@"请求超时，是否重新链接",@"content",@"取消",@"cancel",@"确定",@"ok" ,nil];
//        [self alert:alertDic withTag:102];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        if (alertView.tag==102)
        {
            [self reConnect];
        }
        else if(alertView.tag == 101)
        {
            if ([self.receiveAD count])
            {
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_async(mainQueue, ^(void) {
                    HDBroadcast *item = [self.receiveAD objectAtIndex:0];
                    HDBroadcastViewController *temp = [[HDBroadcastViewController alloc]initWithNibName:@"HDBroadcastViewController" bundle:nil];
                    temp.item = item;
                     HDAppDelegate *delegate = (HDAppDelegate *)[[UIApplication sharedApplication] delegate];
                    [(UINavigationController *)delegate.window.rootViewController pushViewController:temp animated:YES];
                });
                
            }
            
        }
    }
}
@end
