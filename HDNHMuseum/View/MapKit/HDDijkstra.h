//
//  HDDijkstra.h
//  HDMapKit
//
//  Created by Liuzhuan on 13-5-2.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <Foundation/Foundation.h>
static const int maxnum = 100;
static const int maxint = 999999;

class shortPath
{
public:
    shortPath();
    ~shortPath();
    int shortNodesNum;
    void Dijkstra(int n, int v,int *dist,int *prev, int c[maxnum][maxnum]) ;
    NSMutableArray *searchPath(int *prev,int v,int u);
};

@interface HDDijkstra : NSObject
{
    int n;
    int lineCount;
    int c[100][100];
    int dist[100];
    int prev[100];
}
-(id)initWithPath:(NSString *)aPath;
-(NSMutableArray *) shortestPathFrom:(int)a to:(int)b;
//@property(strong,nonatomic)NSMutableArray *resultArray;
@end

