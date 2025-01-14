import 'package:flutter/material.dart';

class AppButtonLogin extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color color;
  final Color? borderColor;
  final Color? textColor;
  final IconData? icon;
  const AppButtonLogin({
    super.key,
    this.icon,
    required this.text,
    required this.onPressed,
    required this.color,
    this.borderColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      // minWidth: MediaQuery.of(context).size.width * .70,
      height: 45,
      color: color,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(width: 2.5, color: borderColor ?? color)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}

// class AppButtonBorderLogin extends StatelessWidget {
//   final String text;
//   final void Function() onPressed;
//   final Color color;
//   final IconData? icon;
//   const AppButtonBorderLogin({
//     Key? key,
//     this.icon,
//     required this.text,
//     required this.onPressed,
//     required this.color,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialButton(
//       onPressed: onPressed,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(5),
//           side: const BorderSide(width: 2.5, color: AppColors.brown)),
//       // minWidth: MediaQuery.of(context).size.width * .70,
//       height: 50,
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width * .70,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (icon != null)
//               Padding(
//                 padding: const EdgeInsets.only(right: 8),
//                 child: Icon(
//                   icon,
//                   color: Colors.white,
//                   size: 25,
//                 ),
//               ),
//             Text(
//               text,
//               style: Theme.of(context)
//                   .textTheme
//                   .headline6
//                   ?.copyWith(color: Colors.black),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class AppButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color color;
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: MediaQuery.of(context).size.width * .1,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white)),
    );
  }
}
