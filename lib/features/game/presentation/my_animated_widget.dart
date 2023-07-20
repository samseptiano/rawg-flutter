import 'package:flutter/material.dart';

class MyAnimatedWidget extends StatelessWidget { 
   MyAnimatedWidget({required this.child, required this.animation}); 
      
   final Widget child; 
   final Animation<double> animation; 
   
   Widget build(BuildContext context) => Center( 
   child: AnimatedBuilder(
      animation: animation, 
      builder: (context, child) => Container( 
         child: Opacity(opacity: animation.value, child: child), 
      ), 
      child: child), 
   ); 
}