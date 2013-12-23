# MCHelpGestureRecognizer
### A simple way to add help functionality into your app without the need for a button

![Example Gif](http://i.imgflip.com/5mww7.gif)

To use, simply import `MCHelpGestureRecognizer.h` and `MCHelpGestureRecognizer.m` into your project (like any other `UIGestureRecognizer`).

```objective-c
helpRecognizer = [[MCHelpGestureRecognizer alloc] initWithTarget:self action:@selector(showHelp)];
[helpRecognizer setDelegate:self];
[self.view addGestureRecognizer:helpRecognizer];
```


And then add a callback method:

```objective-c
-(void)showHelp
{
    NSLog(@"HELP ME!");
}
```


Simples!
