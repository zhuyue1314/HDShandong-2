//
//  Analyse.h
//  SpeakHere
//
//  Created by Li Shijie on 12-11-13.
//
//
#include <Foundation/Foundation.h>

class analyse
{
public:
    int recBufferSize;
    analyse(int a);
    ~analyse();
    int GetFilterValueRrom1(SInt16 buf1[]);
};
