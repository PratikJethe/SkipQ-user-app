import 'package:booktokenapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final BoxShape? shape;
  const UserProfileWidget({Key? key, this.height, this.width, this.shape}) : super(key: key);

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      return Container(
          width: widget.width ?? 60,
          height: widget.height ?? 60 ,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(color: Colors.grey, shape: widget.shape ?? BoxShape.rectangle),
          child: userProvider.user.profilePicUrl != null
              ? Image.network(
                  userProvider.user.profilePicUrl!,
                  fit: BoxFit.cover,
                )
              : FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    // size: 140,
                  ),
                ));
    });
  }
}

class DoctorProfileWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxShape shape;
  final String? url;
  final String? defaultUrl;
  final Widget? errorWidget;
  final double? borderRadius;

  const DoctorProfileWidget(
      {Key? key, this.height, this.width, this.shape = BoxShape.rectangle, this.defaultUrl, this.url, this.errorWidget, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(url);
    return Container(
        width: width ?? 60,
        height: height ?? 100,
        clipBehavior: Clip.hardEdge,
        decoration:
            BoxDecoration(color: Colors.grey, shape: shape, borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(borderRadius ?? 0)),
        child: url != null
            ? Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) => errorWidget ?? Icon(Icons.error),
              )
            : FittedBox(
                fit: BoxFit.contain,
                child: Icon(Icons.person, color: Colors.white
                    // size: 140,
                    ),
              ));
  }
}
