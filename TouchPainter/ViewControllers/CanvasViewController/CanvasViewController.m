//
//  CanvasViewController.m
//  TouchPainter
//
//  Created by liyingpeng on 15/11/8.
//  Copyright © 2015年 liyingpeng. All rights reserved.
//

#import "CanvasViewController.h"
#import "Dot.h"
#import "Stroke.h"

@interface CanvasViewController ()
{
    UIToolbar *_toolBar;
    CGPoint _startPoint;
}

@property(nonatomic, strong) NSMutableArray *commonButtonArray;

@end

@implementation CanvasViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.commonButtonArray = [[NSMutableArray alloc] initWithCapacity:5];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _toolBar = [[UIToolbar alloc] initWithFrame:RECT(0, SCREENHEIGHT - 44., SCREENWIDTH, 44.)];
    [self.view addSubview:_toolBar];
    
    CommandBarButton *trashButton = [[CommandBarButton alloc] init];
    [trashButton setImage:[UIImage imageNamed:@"save"]];
}

// hook up everything with a new Scribble instance
- (void) setScribble:(Scribble *)aScribble
{
    if (_scribble != aScribble)
    {
        _scribble = aScribble;
        
        // add itself to the scribble as
        // an observer for any changes to
        // its internal state - mark
        [_scribble addObserver:self
                    forKeyPath:@"mark"
                       options:NSKeyValueObservingOptionInitial |
         NSKeyValueObservingOptionNew
                       context:nil];
    }
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get a default canvas view
    // with the factory method of
    // the CanvasViewGenerator
    CanvasViewGenerator *defaultGenerator = [[CanvasViewGenerator alloc] init];
    [self loadCanvasViewWithGenerator:defaultGenerator];
    
    // initialize a Scribble model
    Scribble *scribble = [[Scribble alloc] init];
    [self setScribble:scribble];
    
    // setup default stroke color and size
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CGFloat redValue = [userDefaults floatForKey:@"red"];
    CGFloat greenValue = [userDefaults floatForKey:@"green"];
    CGFloat blueValue = [userDefaults floatForKey:@"blue"];
    CGFloat sizeValue = [userDefaults floatForKey:@"size"];
    
    [self setStrokeSize:sizeValue];
    [self setStrokeColor:[UIColor colorWithRed:redValue
                                         green:greenValue
                                          blue:blueValue
                                         alpha:1.0]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Stroke color and size accessor methods

- (void) setStrokeSize:(CGFloat) aSize
{
    // enforce the smallest size
    // allowed
    if (aSize < 5.0)
    {
        _strokeSize = 5.0;
    }
    else
    {
        _strokeSize = aSize;
    }
}


#pragma mark -
#pragma mark Toolbar button hit method

- (IBAction) onBarButtonHit:(id)button
{
    UIBarButtonItem *barButton = button;
    
    if ([barButton tag] == 4)
    {
        [self.undoManager undo];
    }
    else if ([barButton tag] == 5)
    {
        [self.undoManager redo];
    }
}

- (IBAction) onCustomBarButtonHit:(CommandBarButton *)barButton
{
    [[barButton command] execute];
}

#pragma mark -
#pragma mark Loading a CanvasView from a CanvasViewGenerator

- (void) loadCanvasViewWithGenerator:(CanvasViewGenerator *)generator
{
    [_canvasView removeFromSuperview];
    CGRect aFrame = CGRectMake(0, 0, 320, 436);
    CanvasView *aCanvasView = [generator canvasViewWithFrame:aFrame];
    [self setCanvasView:aCanvasView];
    NSInteger viewIndex = [[[self view] subviews] count] - 1;
    [[self view] insertSubview:_canvasView atIndex:viewIndex];
}


#pragma mark -
#pragma mark Touch Event Handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _startPoint = [[touches anyObject] locationInView:_canvasView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint lastPoint = [[touches anyObject] previousLocationInView:_canvasView];
    
    // add a new stroke to scribble
    // if this is indeed a drag from
    // a finger
    if (CGPointEqualToPoint(lastPoint, _startPoint))
    {
        id <Mark> newStroke = [[Stroke alloc] init];
        [newStroke setColor:_strokeColor];
        [newStroke setSize:_strokeSize];
        
        //[scribble_ addMark:newStroke shouldAddToPreviousMark:NO];
        
        // retrieve a new NSInvocation for drawing and
        // set new arguments for the draw command
        NSInvocation *drawInvocation = [self drawScribbleInvocation];
        [drawInvocation setArgument:&newStroke atIndex:2];
        
        // retrieve a new NSInvocation for undrawing and
        // set a new argument for the undraw command
        NSInvocation *undrawInvocation = [self undrawScribbleInvocation];
        [undrawInvocation setArgument:&newStroke atIndex:2];
        
        // execute the draw command with the undraw command
        [self executeInvocation:drawInvocation withUndoInvocation:undrawInvocation];
    }
    
    // add the current touch as another vertex to the
    // temp stroke
    CGPoint thisPoint = [[touches anyObject] locationInView:_canvasView];
    Vertex *vertex = [[Vertex alloc] initWithLocation:thisPoint];
    
    // we don't need to undo every vertex
    // so we are keeping this
    [_scribble addMark:vertex shouldAddToPreviousMark:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint lastPoint = [[touches anyObject] previousLocationInView:_canvasView];
    CGPoint thisPoint = [[touches anyObject] locationInView:_canvasView];
    
    // if the touch never moves (stays at the same spot until lifted now)
    // just add a dot to an existing stroke composite
    // otherwise add it to the temp stroke as the last vertex
    if (CGPointEqualToPoint(lastPoint, thisPoint))
    {
        Dot *singleDot = [[Dot alloc]
                           initWithLocation:thisPoint];
        [singleDot setColor:_strokeColor];
        [singleDot setSize:_strokeSize];
        
        //[scribble_ addMark:singleDot shouldAddToPreviousMark:NO];
        
        // retrieve a new NSInvocation for drawing and
        // set new arguments for the draw command
        NSInvocation *drawInvocation = [self drawScribbleInvocation];
        [drawInvocation setArgument:&singleDot atIndex:2];
        
        // retrieve a new NSInvocation for undrawing and
        // set a new argument for the undraw command
        NSInvocation *undrawInvocation = [self undrawScribbleInvocation];
        [undrawInvocation setArgument:&singleDot atIndex:2];
        
        // execute the draw command with the undraw command
        [self executeInvocation:drawInvocation withUndoInvocation:undrawInvocation];
    }
    
    // reset the start point here
    _startPoint = CGPointZero;
    
    // if this is the last point of stroke
    // don't bother to draw it as the user
    // won't tell the difference
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // reset the start point here
    _startPoint = CGPointZero;
}


#pragma mark -
#pragma mark Scribble observer method

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if ([object isKindOfClass:[Scribble class]] &&
        [keyPath isEqualToString:@"mark"])
    {
        id <Mark> mark = [change objectForKey:NSKeyValueChangeNewKey];
        [_canvasView setMark:mark];
        [_canvasView setNeedsDisplay];
    }
}


#pragma mark -
#pragma mark Draw Scribble Invocation Generation Methods

- (NSInvocation *) drawScribbleInvocation
{
    NSMethodSignature *executeMethodSignature = [_scribble
                                                 methodSignatureForSelector:
                                                 @selector(addMark:
                                                           shouldAddToPreviousMark:)];
    NSInvocation *drawInvocation = [NSInvocation
                                    invocationWithMethodSignature:
                                    executeMethodSignature];
    [drawInvocation setTarget:_scribble];
    [drawInvocation setSelector:@selector(addMark:shouldAddToPreviousMark:)];
    BOOL attachToPreviousMark = NO;
    [drawInvocation setArgument:&attachToPreviousMark atIndex:3];
    
    return drawInvocation;
}

- (NSInvocation *) undrawScribbleInvocation
{
    NSMethodSignature *unexecuteMethodSignature = [_scribble
                                                   methodSignatureForSelector:
                                                   @selector(removeMark:)];
    NSInvocation *undrawInvocation = [NSInvocation
                                      invocationWithMethodSignature:
                                      unexecuteMethodSignature];
    [undrawInvocation setTarget:_scribble];
    [undrawInvocation setSelector:@selector(removeMark:)];
    
    return undrawInvocation;
}

#pragma mark Draw Scribble Command Methods

- (void) executeInvocation:(NSInvocation *)invocation
        withUndoInvocation:(NSInvocation *)undoInvocation
{
    [invocation retainArguments];
    
    [[self.undoManager prepareWithInvocationTarget:self] 
     unexecuteInvocation:undoInvocation
     withRedoInvocation:invocation];
    
    [invocation invoke];
}

- (void) unexecuteInvocation:(NSInvocation *)invocation 
          withRedoInvocation:(NSInvocation *)redoInvocation
{  
    [[self.undoManager prepareWithInvocationTarget:self] 
     executeInvocation:redoInvocation
     withUndoInvocation:invocation];
    
    [invocation invoke];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
