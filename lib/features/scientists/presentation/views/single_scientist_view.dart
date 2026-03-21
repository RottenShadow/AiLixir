import 'package:ailixir/features/scientists/presentation/widgets/single_scientist_view_body.dart';
import 'package:flutter/widgets.dart';

class SingleScientistView extends StatelessWidget {
  static const String routeName = "/singlescientist";
  const SingleScientistView({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleScientistViewBody();
  }
}
