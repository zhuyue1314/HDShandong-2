//
//  HDDijkstra.m
//  HDMapKit
//
//  Created by Liuzhuan on 13-5-2.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import "HDDijkstra.h"
#import "Graphics.h"


@interface HDDijkstra ()

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic)NSMutableArray *graphics;

@end

@implementation HDDijkstra

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

-(id)initWithPath:(NSString *)aPath
{
    self = [super init];
    if (self)
    {
        //_resultArray = [NSMutableArray arrayWithCapacity:0];
        [self fetchData];
        
    }
    return self;
}
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HDDijkstra" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
//    if ([[self applicationLibraryURLDirectory]URLByAppendingPathComponent:@"HDDijkstra.sqlite"]) {
//        
//    }
    
    NSURL *storeURL =[[NSBundle mainBundle ]URLForResource:@"HDDijkstra" withExtension:@"sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        
    }
    return _persistentStoreCoordinator;
}
-(void)fetchData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Graphics"
                                   inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    NSError *error = nil;
    NSMutableArray *FetchResults = [[self.managedObjectContext
                                     executeFetchRequest:fetchRequest
                                     error:&error]mutableCopy];
    self.graphics = FetchResults;
    n = 6;
    lineCount = [FetchResults count];
   
    for(int i=1; i<=n; ++i)
        for(int j=1; j<=n;++j)
            c[i][j] = maxint;
    
    for(int i=1; i<=lineCount; ++i)
	{
        Graphics *graphics = [self.graphics objectAtIndex:i-1];
        int p = [graphics.from intValue];
        int q = [graphics.to intValue];
        int len = [graphics.value intValue];
		if(len < c[p][q])       // 有重边
		{
			c[p][q] = len;
           
        
			c[q][p] = len;      //如许默示无向图
		}
	}
    for(int i=0; i<=n; i++)
        dist[i] = maxint;
    //[self shortestPathFrom:5 to:1];
}
-(NSMutableArray *) shortestPathFrom:(int)a to:(int)b
{
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    shortPath *shortPath = new class shortPath();
    
    shortPath->Dijkstra(n, a, dist, prev, c);
    
    NSMutableArray *result = shortPath->searchPath(prev, a,b);
    
    for (int i= shortPath->shortNodesNum ; i >=0; --i)
    {
        [resultArray addObject:[result objectAtIndex:i]];
    }
    return resultArray;
}
-(NSURL *)applicationLibraryURLDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
void shortPath::Dijkstra(int n, int v,int *dist,int *prev, int c[maxnum][maxnum])
{
    bool s[maxnum];    // 断定是否已存进该点到S凑集中
	for(int i=1; i<=n; ++i)
	{
		dist[i] = c[v][i];
		s[i] = 0;     // 初始都未用过该点
		if(dist[i] == maxint)
			prev[i] = 0;
		else
			prev[i] = v;
	}
	dist[v] = 0;
	s[v] = 1;
    
	// 依次将未放进S凑集的结点中，取dist[]最小值的结点，放进连络S中
	// 一旦S包含了所有V中顶点，dist就记录了从源点到所有其他顶点之间的最短路径长度
	for(int i=2; i<=n; ++i)
	{
		int tmp = maxint;
		int u = v;
		// 找出当前未应用的点j的dist[j]最小值
		for(int j=1; j<=n; ++j)
            if((!s[j]) && dist[j]<tmp)
            {
                u = j;              // u保存当前邻接点中心隔最小的点的号码
                tmp = dist[j];
            }
		s[u] = 1;    // 默示u点已存进S凑集中
        
		// 更新dist
		for(int j=1; j<=n; ++j)
            if((!s[j]) && c[u][j]<maxint)
            {
                int newdist = dist[u] + c[u][j];
                if(newdist < dist[j])
                {
                    dist[j] = newdist;
                    prev[j] = u;
                }
            }
	}
}
NSMutableArray *shortPath::searchPath(int *prev,int v,int u)
{
    //int *que;
    NSMutableArray *array = [NSMutableArray array];
    //que = new int[maxnum];
	//int que[maxnum];
	int tot = 0;
    //NSString *string = [NSString stringWithFormat:@"%d",u];
	//que[tot] = u;
    //[array insertObject:[NSString stringWithFormat:@"%d",u] atIndex:tot];
    [array addObject:[NSString stringWithFormat:@"%d",u]];
	tot++;
	int tmp = prev[u];
	while(tmp != v)
	{
		//que[tot] = tmp;
        //[array insertObject:[NSString stringWithFormat:@"%d",tmp] atIndex:tot];
        [array addObject:[NSString stringWithFormat:@"%d",tmp]];
		tot++;
		tmp = prev[tmp];
	}
	//que[tot] = v;
    //[array insertObject:[NSString stringWithFormat:@"%d",v] atIndex:tot];
    [array addObject:[NSString stringWithFormat:@"%d",v]];
    shortNodesNum = tot;
	for(int i=tot; i>=0; --i)
        if(i != 0)
            //printf("%d->",que[i]);//(@"%d->",que[i]) ;
            NSLog(@"%@->",[array objectAtIndex:i]);
        else
            //printf("%d",que[i]);
            NSLog(@"%@->",[array objectAtIndex:i]);
//    // NSLog(@"%d",que[i]);
    return array;
}
shortPath::shortPath()
{
    shortNodesNum = 0;
}
shortPath::~shortPath()
{
    
}