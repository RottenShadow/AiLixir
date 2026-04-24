import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class _AdmetViewState extends State<AdmetView> {
  //File? csvFile;
  TextEditingController controller = TextEditingController();
  int _state = 0;

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case 1:
        return _result();
      default:
        return _initial();
    }
  }

  Widget _result() {
    return Center();
  }

  Widget _initial() {
    return Container(
      color: AppColors.slate1000,
      child: Center(
        child: Container(
          width: 0.6.sw,
          height: 0.6.sh,
          decoration: BoxDecoration(
            color: AppColors.slate800,

            borderRadius: BorderRadiusGeometry.circular(12),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 0.1.sw),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "ADMET",
                  style: AppTextStyles.xl.copyWith(
                    color: AppColors.brandBlue,
                    fontFamily: "UniNeueTrial",
                  ),
                ),
                TextField(
                  maxLines: null,
                  minLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Your Compounds",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.brandBlue),
                    ),
                  ),
                  controller: controller,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        // context.navigateTo(
                        // SimilarityResultView.routeName,
                        // arguments: controller.text,
                        // );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                      ),
                      color: AppColors.brandBlue,
                      child: Text(
                        "Submit Compound List",
                        style: AppTextStyles.labelmedium,
                      ),
                    ),
                    //MaterialButton(
                    //  onPressed: () async {
                    //    FilePickerResult? result = await FilePicker.pickFiles(
                    //      withData: true,
                    //      type: FileType.custom,
                    //      allowedExtensions: ["csv"],
                    //      readSequential: true,
                    //    );

                    //    if (result != null) {
                    //      //print(result.files.first.extension);
                    //      //PlatformFile file = result.files.first;
                    //    } else {
                    //      // User canceled the picker
                    //    }
                    //  },
                    //  shape: RoundedRectangleBorder(
                    //    borderRadius: BorderRadiusGeometry.circular(10),
                    //  ),
                    //  color: AppColors.green700,
                    //  child: Text(
                    //    "Submit CSV File",
                    //    style: AppTextStyles.labelmedium,
                    //  ),
                    //),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdmetView extends StatefulWidget {
  const AdmetView({super.key});
  @override
  State<AdmetView> createState() => _AdmetViewState();
}
