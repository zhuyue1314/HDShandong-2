//
//  Analyse.m
//  SpeakHere
//
//  Created by Li Shijie on 12-11-13.
//
//

#include "Analyse.h"

analyse::analyse(int a)
{
    recBufferSize = a;
}
analyse::~analyse()
{
    
}
int analyse:: GetFilterValueRrom1(SInt16 buf[])
{
    int i,l=0,f,s;
    int h1,h2,h4;
    int ret=0;
    
    Byte *arr=new Byte[recBufferSize/4];
    int arrnum;
    
    Byte *arr1=new Byte[51];
    Byte arrnum1;
    
    Byte *arr2=new Byte[17];
    Byte arrnum2;
	
    Boolean isstart=false;
    int  is2or4=0;
    
    
    //printf("%d\n:",recBufferSize);
    //     for (int i = 0; i <recBufferSize/2 ; i++)
    //     {
    //     printf("%d:",buf[i]);
    //     }
    
    i=0;
    f=0;
    s=0;
    arrnum=0;
    arrnum1=0;
    arrnum2=0;
	
    int ForS=0;
    while(i<recBufferSize/2-2)
    {
        if(buf[i]<0)
        {
            if(ForS==2)
            {
                if(f>0 && s>0)
                {
                    if(f+s>=3 && f+s<=5)
                    {
                        if(arrnum>=2 && arr[arrnum-2]==4 && arr[arrnum-1]==0) arrnum--;
                        arr[arrnum]=4;
                    }
                    else if(f+s>=7 && f+s<=9)
                    {
                	    if(arrnum>=2 && arr[arrnum-2]==2 && arr[arrnum-1]==0) arrnum--;
                	    arr[arrnum]=2;
                    }
                    else if(f+s>=14 && f+s<=17)
                    {
                	    arr[arrnum]=1;
                    }
                    else
                    {
                	    arr[arrnum]=0;
                    }
                    arrnum++;
                }
                f=0;
                s=0;
            }
            ForS=1;
            s=0;
            f++;
        }
        else
        {
            ForS=2;
            s++;
        }
        i++;
    }
    
    //     printf("%d\n:",arrnum);
    //        for (int i= 0; i< arrnum; i++)
    //        {
    //            printf("===222:%d,",arr[i]);
    //        }
    //
    i=0;
    h1=0;
    h2=0;
    h4=0;
    arrnum1=0;
    arrnum2=0;
    isstart=false;
    
    while(i<arrnum)
    {
        if(isstart==false)
        {
            if(arr[i]==1) h1++;
            else
            {
                if(h1>0) h1--;
            }
            if(h1>=8)//-----------------------
            {
                isstart=true;
                h1=0;
                is2or4=0;
            }
            h2=0;
            h4=0;
        }
        else
        {
            if(arr[i]==2)
            {
                if(is2or4!=2) is2or4=2;
                else is2or4=0;
                h2++;
                if(h1>0)h1--;
                if(h4>0 && is2or4!=2)h4--;
            }
            else if(arr[i]==4)
            {
                if(is2or4!=4) is2or4=4;
                else is2or4=0;
                h4++;
                if(h1>0)h1--;
                if(h2>0 && is2or4!=4) h2--;
            }
            else
            {
                
            }
            if(is2or4==2)
            {
                is2or4=0;
                if(h4>=4 && h4<=8)//----------------------------
                {
                    arr1[arrnum1++]=1;
                    
                    h4=0;
                }
                else if(h4>=10 && h4<=15)//----------------------
                {
                    arr1[arrnum1++]=1;
                    
                    arr1[arrnum1++]=1;
                    
                    h4=0;
                }
            }
            else if(is2or4==4)
            {
        	    is2or4=0;
                if(h2>=3 && h2<=7)//------------------------------
                {
                    arr1[arrnum1++]=0;
                    
                    h2=0;
                }
                else if(h2>=8 && h2<=15)//----------------------
                {
                    arr1[arrnum1++]=0;
                    
                    arr1[arrnum1++]=0;
                    
                    h2=0;
                }
            }
        }
        if(arrnum1>=48)
        {
            
            //            printf("%d\n:",arrnum1);
            //            for (int i= 0; i< arrnum1; i++)
            //            {
            //                printf("%d-",arr1[i]);
            //            }
            
            for(l=0;l<arrnum1;l+=3)
            {
                if(arr1[l]==1 && arr1[l+1]==0 && arr1[l+2]==0)  arr2[arrnum2++]=0;
                if(arr1[l]==1 && arr1[l+1]==1 && arr1[l+2]==0)  arr2[arrnum2++]=1;
            }
            if(arrnum2>=16)
            {
                /*
                 aa="";
                 aa= String.valueOf((int)arrnum2);
                 for(l=0;l<arrnum2;l++)
                 {
                 String bb= String.valueOf((int)arr2[l]);
                 aa=aa+" "+bb;
                 }
                 Log.e("===444", aa);
                 */
                if(((arr2[4]+arr2[8]+arr2[12]) %2)==(arr2[0]+1)%2)
                    if(((arr2[5]+arr2[9]+arr2[13]) %2)==(arr2[1]+1)%2)
                        if(((arr2[6]+arr2[10]+arr2[14]) %2)==(arr2[2]+1)%2)
                			if(((arr2[7]+arr2[11]+arr2[15]) %2)==(arr2[3]+1)%2)
                			{
                                ret=arr2[15]+arr2[14]*2+arr2[13]*4+arr2[12]*8+arr2[11]*16+arr2[10]*32+arr2[9]*64+arr2[8]*128+arr2[7]*256+arr2[6]*512+arr2[5]*1024+arr2[4]*2048;
                			}
            }
            h1=0;
            h2=0;
            h4=0;
            arrnum1=0;
            break;
        }
        i++;
    }//while(i<arrnum)
    /*
     aa="";
     aa= String.valueOf((int)arrnum1);
     Log.e("===555", aa);
     */
    delete arr;
    delete arr1;
    delete arr2;
    return ret;
}
