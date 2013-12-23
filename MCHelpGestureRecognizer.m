//
//  MCHelpGestureRecognizer.m
//  HelpGestureRecognizer
//
//  Created by Max Chuquimia on 22/12/13.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

#import "MCHelpGestureRecognizer.h"

@implementation MCHelpGestureRecognizer
-(id)initWithTarget:(id)target action:(SEL)action
{
    if ((self = [super initWithTarget:target action:action]))
    {
        curvePoints = [[NSMutableArray alloc] init];
        [self reset];
    }
    return self;
}

-(void)reset
{
    //NSLog(@"Resetting");
    
    listenForPoint = FALSE;
    [curvePoints removeAllObjects];
}

-(BOOL)madeValidCurveWithDot:(CGPoint )dot
{
    CGPoint highestPoint = [self highestPoint];
    CGPoint lastPoint = CGPointFromString([curvePoints lastObject]);
    
    CGPoint rightmostPoint = [self rightmostPoint];
    CGPoint firstPoint = CGPointFromString([curvePoints firstObject]);
    
    //the width and height of the ? must be greater than 100 points
    float widthOfMark = (rightmostPoint.x - firstPoint.x);
    float heightOfMark = (dot.y - highestPoint.y);
    
    //This next part is a bit iffy...
    if (widthOfMark < 100)
    {
        //NSLog(@"Width of ? not great enough");
        return FALSE;
    }
    
    if (heightOfMark < 100)
    {
        //NSLog(@"Height of ? not great enough");
        return FALSE;
    }
    
    if (firstPoint.x >= lastPoint.x)
    {
        //NSLog(@"Last point too far left");
        return FALSE;
    }
    
    if (firstPoint.x >= dot.x)
    {
        //NSLog(@"Dot too far left");
        return FALSE;
    }
    
    if (highestPoint.x >= rightmostPoint.x)
    {
        //NSLog(@"Highest point was the furthest point to the right");
        return FALSE;
    }
    
    if (firstPoint.x >= highestPoint.x)
    {
        //NSLog(@"Highest point was further left than the first point");
        return FALSE;
    }
    
    if (dot.y <= lastPoint.y)
    {
        //NSLog(@"Dot was drawn higher than last point");
        return FALSE;
    }
    
    if (lastPoint.y <= firstPoint.y)
    {
        //NSLog(@"Last point was further up the screen than the first point");
        return FALSE;
    }
    
    if (lastPoint.y <= rightmostPoint.y)
    {
        //NSLog(@"Last point was further up the screen than the rightmost point");
        return FALSE;
    }
    
    return TRUE;
}

-(CGPoint )highestPoint
{
    CGPoint p = CGPointFromString((NSString *)[curvePoints firstObject]);
    
    for (NSString *s in curvePoints)
    {
        CGPoint aPoint = CGPointFromString(s);
        if (aPoint.y < p.y) {
            p = aPoint;
        }
    }
    
    return p;
}

-(CGPoint )rightmostPoint
{
    CGPoint p = CGPointFromString((NSString *)[curvePoints firstObject]);
    
    for (NSString *s in curvePoints)
    {
        CGPoint aPoint = CGPointFromString(s);
        if (aPoint.x > p.x) {
            p = aPoint;
        }
    }
    
    return p;
}

#pragma mark - Touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint aPoint = [[touches anyObject] locationInView:self.view];
    
    if (listenForPoint)
    {
        if ([self madeValidCurveWithDot:aPoint])
        {
            self.state = UIGestureRecognizerStateRecognized;
        }
        else
        {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
    else
    {
        [curvePoints addObject:NSStringFromCGPoint(aPoint)];
    }
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    CGPoint aTouch = [[touches anyObject] locationInView:self.view];
    
    if (!listenForPoint)
    {
        [curvePoints addObject:NSStringFromCGPoint(aTouch)];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (listenForPoint)
    {
        [self reset];
    }
    else
    {
        listenForPoint = TRUE;
        
        //cancel the drawing if the user takes too long to dot the ?
        [self performSelector:@selector(reset) withObject:nil afterDelay:0.25f];
    }
}

@end