
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:intl/intl.dart';
import 'package:stockapp/main.dart';

void _defaultCallback(){
}


navigateTo(BuildContext context,Widget currentPage, Widget targetPage, {String animationType = ''}){
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if(animationType==''){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => targetPage), 
      );
    }
    else if(animationType=='scrollUp'){
      Navigator.of(context).pushReplacement(
        _scrollUpTransition(targetPage, currentPage),
      );
    }
    else if(animationType=='scrollDown'){
      Navigator.of(context).pushReplacement(
        _scrollDownTransition(targetPage, currentPage),
      );
    }
    else if(animationType=='scrollRight'){
      Navigator.of(context).pushReplacement(
        _scrollRightTransition(targetPage, currentPage),
      );
    }
    else if(animationType=='scrollLeft'){
      Navigator.of(context).pushReplacement(
        _scrollLeftTransition(targetPage, currentPage),
      );
    }
  });
}

PageRouteBuilder _scrollLeftTransition(
  Widget enterPage,
  Widget exitPage,
) {

  Curve curvetype = Curves.easeOutQuint;
  Duration duration = Duration(milliseconds: 1000);

  return PageRouteBuilder(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) =>
        enterPage,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) =>
        Stack(
      children: <Widget>[
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation, 
              curve: curvetype,)),
              child: enterPage,
        ),
        SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(1.0, 0.0),
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: curvetype,
            )
          ),
          child: exitPage,
        ),
      ],
    ),
  transitionDuration: duration,
  );
}

PageRouteBuilder _scrollRightTransition(
  Widget enterPage,
  Widget exitPage,
) {

  Curve curvetype = Curves.easeOutQuint;
  Duration duration = Duration(milliseconds: 1000);

  return PageRouteBuilder(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) =>
        enterPage,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) =>
        Stack(
      children: <Widget>[
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation, 
              curve: curvetype,)),
              child: enterPage,
        ),
        SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-1.0, 0.0),
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: curvetype,
            )
          ),
          child: exitPage,
        ),
      ],
    ),
  transitionDuration: duration,
  );
}

PageRouteBuilder _scrollDownTransition(
  Widget enterPage,
  Widget exitPage,
) {

  Curve curvetype = Curves.easeOutQuint;
  Duration duration = Duration(milliseconds: 1000);

  return PageRouteBuilder(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) =>
        enterPage,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) =>
        Stack(
      children: <Widget>[
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation, 
              curve: curvetype,)),
              child: enterPage,
        ),
        SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0.0, -1.0),
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: curvetype,
            )
          ),
          child: exitPage,
        ),
      ],
    ),
  transitionDuration: duration,
  );
}

PageRouteBuilder _scrollUpTransition(
  Widget enterPage,
  Widget exitPage,
) {

  Curve curvetype = Curves.easeOutQuint;
  Duration duration = Duration(milliseconds: 1000);

  return PageRouteBuilder(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) =>
        enterPage,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) =>
        Stack(
      children: <Widget>[
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation, 
              curve: curvetype,)),
              child: enterPage,
        ),
        SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0.0, 1.0),
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: curvetype,
            )
          ),
          child: exitPage,
        ),
      ],
    ),
  transitionDuration: duration,
  );
}

// PageRouteBuilder _slideFromBottom(Widget targetPage){
//   return 
//   PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => targetPage,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(0.0, 1.0);
//       const end = Offset.zero;
//       const curve = Curves.easeInOut;

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//       var offsetAnimation = animation.drive(tween);

//       return SlideTransition(position: offsetAnimation, child: child);
//     },);
// }

createButton({
  String text = '',
  Function() onPressed = _defaultCallback, 
  double fontSize=16, 
  FontWeight fontWeight= FontWeight.normal, 
  Color bgColor = Colors.transparent, 
  Color textColor = Colors.black, 
  double letterSpacing=0, 
  double px = 1, 
  double py = 1, 
  double bradius = 0, // border radius
  double ml = 0,
  double mt = 0,
  double mr = 0,
  double mb = 0,
  Color bColor = Colors.transparent, // border color
  double bWidth = 0,
  BorderStyle bStyle = BorderStyle.none,
  IconData? endingIcon,
  Color? iconColor,
  double? iconSize,
  double? iconOffset,
  }
  ){
  if(endingIcon == null){

  return
  Padding(
    padding: EdgeInsets.fromLTRB(ml, mt, mr, mb), // set top and bottom padding
    child:
    TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: bgColor,
        padding: EdgeInsets.fromLTRB(px, py, px, py),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: bColor, width: bWidth, style: bStyle),
          borderRadius: BorderRadius.circular(bradius),
        ),
      ),
      child: 
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
          )),
    )
  );
  }
  else{

  return
  Padding(
    padding: EdgeInsets.fromLTRB(ml, mt, mr, mb), // set top and bottom padding
    child:
    TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: bgColor,
        padding: EdgeInsets.fromLTRB(px, py, px, py),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: bColor, width: bWidth, style: bStyle),
          borderRadius: BorderRadius.circular(bradius),
        ),
      ),
      child: 
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

        Expanded(
        flex: 7,
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
                letterSpacing: letterSpacing,
            )),
          ],
        )
        ),

        Expanded(
        flex: 3,
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              endingIcon,
              color: iconColor,
              size: iconSize,
            ),
          ],
        ),
        ),

        ],

      )
    )
  );
  }
}  

createTextField({
  String hintText='', 
  String labelText = '',
  double bradius=0,
  double fontSize= 16,
  double letterSpacing = 0,
  FontWeight fontWeight = FontWeight.normal, 
  Color textColor= Colors.black,
  double ml = 0,
  double mt = 0,
  double mr = 0,
  double mb = 0,
  Function(String)? onChanged,
  Function(String)? onSubmitted,
  TextInputAction? inputAction,
  TextEditingController? controller,
  bool? enabled,
  FocusNode? focusNode,
  }){
  
  if(labelText == ''){
    return
    Padding(
      padding: EdgeInsets.fromLTRB(ml, mt, mr, mb), // set top and bottom padding
      child:
      TextField(
        focusNode: focusNode,
        enabled: enabled,
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: inputAction,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(bradius),
          ),
        ),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor 
        ),
      )
    );
  }
  else{
    return
      Padding(
        padding: EdgeInsets.fromLTRB(ml, mt, mr, mb), // set top and bottom padding
        child:
        TextField(
          focusNode: focusNode,
          enabled: enabled,
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textInputAction: inputAction,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(bradius),
            ),
          ),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
            letterSpacing: letterSpacing,
          ),
        )
      );
  }
}

createFormTextField({
  String hintText='', 
  String labelText = '',
  double bradius=0,
  double fontSize= 16,
  double letterSpacing = 0,
  FontWeight fontWeight = FontWeight.normal, 
  Color textColor= Colors.black,
  double ml = 0,
  double mt = 0,
  double mr = 0,
  double mb = 0,
  TextEditingController? controller,
  String? Function(String?)? validator,
  bool? enabled,
  FocusNode? focusNode,
  TextInputType? keyboardType,
  Function()? onEditComplete,
  Function(String?)? onChanged,
  void Function(PointerDownEvent)? onTapOutside,
  }){
  
  if(labelText == ''){
    return
    Padding(
      padding: EdgeInsets.fromLTRB(ml, mt, mr, mb), // set top and bottom padding
      child:
      TextFormField(
        focusNode: focusNode,
        enabled: enabled,
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        onEditingComplete: onEditComplete,
        onTapOutside: onTapOutside,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(bradius),
          ),
        ),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor 
        ),
      )
    );
  }
  else{
    return
      Padding(
        padding: EdgeInsets.fromLTRB(ml, mt, mr, mb), // set top and bottom padding
        child:
        TextFormField(
          focusNode: focusNode,
          enabled: enabled,
          controller: controller,
          onChanged: onChanged,
          onEditingComplete: onEditComplete,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(bradius),
            ),
          ),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
            letterSpacing: letterSpacing,
          ),
        )
      );
  }
}

createText(String text, {
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.normal,
  double letterSpacing = 0,
  Color textColor = Colors.black,
  double ml = 0,
  double mt = 0,
  double mr = 0,
  double mb = 0,
  TextOverflow? overflow,
  TextAlign? textAlign,
  bool? softWrap,
  TextDecoration? textDecoration,
  }){
  return
  Padding(
    padding: EdgeInsets.fromLTRB(ml, mt, mr, mb), // set top and bottom padding
    child:
    Text(
      text,
      softWrap: softWrap,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: textColor,
        letterSpacing: letterSpacing,
        overflow: overflow,
        decoration: textDecoration, 
      ),
    )
  );
}

createLink({
  String text = 'link',
  double fontSize = 16,
  double letterSpacing = 0,
  FontWeight fontWeight = FontWeight.normal,
  Color textColor = Colors.blue,
  TextDecoration textDecor = TextDecoration.underline,
  Function() onTap = _defaultCallback,
  double ml = 0,
  double mt = 0,
  double mr = 0,
  double mb = 0,
}){
  return
  Padding(
    padding: EdgeInsets.fromLTRB(ml, mt, mr, mb), // set top and bottom padding
    child:
    InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          decoration: textDecor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
        )
      ),
    )
  );
}

createFormDropdownMenu({
  String hintText='', 
  String labelText = '',
  double bradius=0,
  double fontSize= 16,
  double letterSpacing = 0,
  FontWeight fontWeight = FontWeight.normal, 
  Color textColor= Colors.black,
  double ml = 0,
  double mt = 0,
  double mr = 0,
  double mb = 0,
  TextEditingController? controller,
  String? Function(String?)? validator,
  String? dropdownValue='',
  List<String>? dropdownItems,
  void Function(String?)? onChanged,
  }){
  
  return
  Padding(
    padding: EdgeInsets.fromLTRB(ml, mt, mr, mb), // set top and bottom padding
    child:
    DropdownButtonFormField<String>(
    borderRadius: BorderRadius.circular(bradius),
    elevation: 1,
    value: dropdownValue,
    validator: validator,
    items: dropdownItems?.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            )
          ),
      );
    }).toList(),
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(bradius)
      )
    ),
    )
  );
}

Widget createFormAdvDropdownMenu({
  String hintText = '',
  String labelText = '',
  double bradius = 0,
  double fontSize = 16,
  double letterSpacing = 0,
  FontWeight fontWeight = FontWeight.normal,
  Color textColor = Colors.black,
  double ml = 0,
  double mt = 0,
  double mr = 0,
  double mb = 0,
  TextEditingController? controller,
  String? Function(String?)? validator,
  Map<String, dynamic>? selectedOption, // Map to hold selected value and display text
  List<Map<String, dynamic>>? dropdownItems, // List of items with value and display text
  void Function(Map<String, dynamic>?)? onChanged,
}) {
  String dropdownValue = selectedOption?['OutletID'].toString() ?? '';
  String displayText = selectedOption?['OutletName'] ?? '';

  return Padding(
    padding: EdgeInsets.fromLTRB(ml, mt, mr, mb),
    child: DropdownButtonFormField<String>(
      borderRadius: BorderRadius.circular(bradius),
      elevation: 1,
      value: dropdownValue,
      validator: validator,
      items: dropdownItems?.map((Map<String, dynamic> item) {
        return DropdownMenuItem<String>(
          value: item['OutletID'].toString(),
          child: Text(
            item['OutletName'],
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        final selected = dropdownItems?.firstWhere(
          (item) => item['OutletID'].toString() == value,
          // orElse: () => {'OutletID': '0', 'OutletName': ''},
        );
        onChanged?.call(selected);
      },
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(bradius),
        ),
      ),
    ),
  );
}


showAlertDialog({
    required BuildContext context, 
    String title = 'Title',
    String message = 'Message',
    Color bgColor = Colors.white,
    Color titleColor = Colors.black,
    double titleFontSize = 22,
    FontWeight titleFontWeight = FontWeight.w600,
    Color msgColor = Colors.grey,
    double msgFontSize = 16,
    FontWeight msgFontWeight = FontWeight.w500,
    double bradius = 0,
    double px = 30,
    double py = 30,
    bool dismissable = true,

    // button params
    String btnText = '',
    Function() btnOnPressed = _defaultCallback, 
    double btnFontSize=16, 
    FontWeight btnFontWeight= FontWeight.normal, 
    Color btnBgColor = Colors.transparent, 
    Color btnTextColor = Colors.black, 
    double btnLetterSpacing=0, 
    double btnPx = 1, 
    double btnPy = 1, 
    double btnBradius = 0,
    double btnMl = 0,
    double btnMt = 0,
    double btnMr = 0,
    double btnMb = 0,
    Color btnBColor = Colors.transparent,
    double btnBWidth = 0,
    BorderStyle btnBStyle = BorderStyle.none,
    }){
  return 
  showDialog(
    context: context,
    barrierDismissible: dismissable,
    builder: (BuildContext context){
      return AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(px, py, px, py),
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(bradius),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: titleFontSize,
            fontWeight: titleFontWeight,
          ),
          ),

        content: Text(
          message,
          style: TextStyle(
            color: msgColor,
            fontSize: msgFontSize,
            fontWeight: msgFontWeight,
          ),
          ),
        actions: [
          Row(
            children: [
              Expanded(
                child: 
                createButton(
                  text: btnText,
                  onPressed: (){
                    // Navigator.of(context).pop();
                    return btnOnPressed();
                    },
                  // onPressed: btnOnPressed,
                  fontSize: btnFontSize,
                  fontWeight: btnFontWeight,
                  bgColor: btnBgColor,
                  textColor: btnTextColor,
                  letterSpacing: btnLetterSpacing,
                  px: btnPx,
                  py: btnPy,
                  bradius: btnBradius,
                  ml: btnMl,
                  mt: btnMt,
                  mr: btnMr,
                  mb: btnMb,
                  bColor: btnBColor,
                  bWidth: btnBWidth,
                  bStyle: btnBStyle,
                  ),
              ),
            ],
          ),
        ],
      );
    }
  );
}

getStatusColor(String status){
if(status == "Active"){
  return Colors.greenAccent;
}
if(status == "Complete"){
  return Colors.greenAccent;
}
else if(status == "Pending"){
  return Colors.amber;
}
else if(status == "Inactive"){
  return Colors.redAccent;
}
else{
  return Colors.grey;
}

}

createSwitch({
  bool value = false,
  Color activeColor = Colors.greenAccent,
  Color inactiveThumbColor = Colors.redAccent,
  Color? inactiveTrackColor,
  Color? activeTrackColor,
  Function(bool)? onChanged,
}){
  return
  Switch(
    value: value,
    activeColor: activeColor,
    activeTrackColor: activeTrackColor,
    inactiveThumbColor: inactiveThumbColor,
    inactiveTrackColor: inactiveTrackColor,
    onChanged: onChanged,

  );
}

createLoadingDialog({
  double elevation = 4,
  double bradius = 0,
  double height = 200,
  String? message,
  Color loadingColor = Colors.red,
  Color bgColor = Colors.white,
  double fontSize = 20,
  FontWeight fontWeight = FontWeight.w600,
  double messageOffset = 0,
}){
  return
  Dialog(
    elevation: elevation,
    backgroundColor: bgColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(bradius)
    ),
    child:
    Container(
      height: 200,
      child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            message!=null?createText(
              fontSize: fontSize,
              fontWeight: fontWeight,
              message,
              mb: messageOffset, 
            ):null,
            LoadingAnimationWidget.staggeredDotsWave(color: Colors.red, size: 50),
          ]
        ),
    ),
  );
}


showTextLoadingDialog({
    required BuildContext context, 
    String title = 'Title',
    Color bgColor = Colors.white,
    Color titleColor = Colors.black,
    double titleFontSize = 22,
    FontWeight titleFontWeight = FontWeight.w600,
    Color msgColor = Colors.grey,
    double msgFontSize = 16,
    FontWeight msgFontWeight = FontWeight.w500,
    double bradius = 0,
    double px = 30,
    double py = 30,
    bool dismissable = false,
    Color loadingColor = Colors.red,
    String message = '',
    }){
  return 
  showDialog(
    context: context,
    barrierDismissible: dismissable,
    builder: (BuildContext context){
      return 
      AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(px, py, px, py),
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(bradius),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: titleFontSize,
            fontWeight: titleFontWeight,
          ),
          ),

        content:       
        SizedBox(
          height: sHeight * 0.15,
          child: 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.staggeredDotsWave(color: loadingColor, size: 50),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                createText(
                message,
                mt: 10
                ),
              ],
            ),
            ],
          )
        )
        );
    }
  );
}

showLoadingDialog({
    required BuildContext context, 
    String title = 'Title',
    Color bgColor = Colors.white,
    Color titleColor = Colors.black,
    double titleFontSize = 22,
    FontWeight titleFontWeight = FontWeight.w600,
    Color msgColor = Colors.grey,
    double msgFontSize = 16,
    FontWeight msgFontWeight = FontWeight.w500,
    double bradius = 0,
    double px = 30,
    double py = 30,
    bool dismissable = true,
    Color loadingColor = Colors.red,
    }){
  return 
  showDialog(
    context: context,
    barrierDismissible: dismissable,
    builder: (BuildContext context){
      return 
      AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(px, py, px, py),
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(bradius),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: titleFontSize,
            fontWeight: titleFontWeight,
          ),
          ),

        content:       
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.staggeredDotsWave(color: loadingColor, size: 50),
            ],
          ),
        );
    }
  );
}

String timestampToStr(Timestamp ts, String format){
  Timestamp timestamp = ts; 

  DateTime dateTime = timestamp.toDate();

  String formattedDate = DateFormat(format).format(dateTime);

  return formattedDate;

}

String abbvString(String input) {
  List<String> names = input.split(" ");

  if (names.length > 1) {
    String firstName = names[0];
    String lastName = names[names.length - 1];

    // Take the first two characters of the first name
    String abbreviatedFirstName = firstName.length >= 2 ? firstName.substring(0, 2) : firstName;

    // Take the first character of the last name
    String abbreviatedLastName = "${lastName.length > 0 ? lastName.substring(0, 1) : ''}.";

    // Combine the abbreviated first name and last name
    return "$abbreviatedFirstName $abbreviatedLastName".trim();
  } else {
    return input; // Return the original string if there's only one name
  }
}