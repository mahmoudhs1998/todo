import 'package:flutter/cupertino.dart';

class NoGlowBehavior extends ScrollBehavior
{
  Widget buildViewPortChrome(BuildContext context, Widget child , AxisDirection axisDirection)
  {
    return child;

  }
}