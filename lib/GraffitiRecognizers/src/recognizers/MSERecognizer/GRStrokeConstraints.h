#ifndef __GRStrokeConstraints_H__
#define __GRStrokeConstraints_H__

#import <Foundation/Foundation.h>

enum GRStrokeConstraintsEnum
{
/*1*/    StartTopLeft     = 1 << 0,
/*2*/    StartTopRight    = 1 << 1,
/*4*/    StartBottomLeft  = 1 << 2,
/*8*/    StartBottomRight = 1 << 3,
/*15*/   StartAny = StartTopLeft | StartTopRight | StartBottomLeft | StartBottomRight,

/*16*/   EndTopLeft       = 1 << 4,
/*32*/   EndTopRight      = 1 << 5,
/*64*/   EndBottomLeft    = 1 << 6,
/*128*/  EndBottomRight   = 1 << 7,
/*240*/  EndAny = EndTopLeft | EndTopRight | EndBottomLeft | EndBottomRight,

/*255*/  Any = StartAny | EndAny,
};
typedef NSUInteger GRStrokeConstraints;

#endif // __GRStrokeConstraints_H__

