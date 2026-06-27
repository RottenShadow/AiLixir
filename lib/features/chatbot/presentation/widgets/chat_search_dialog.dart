import 'package:ailixir/core/themes/app_colors.dart';
import 'package:ailixir/core/themes/app_text_styles.dart';
import 'package:ailixir/core/widgets/text_form_field/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChatSearchDialog extends StatefulWidget {
  final List<String> Function(String) onSearch;

  const ChatSearchDialog({super.key, required this.onSearch});

  @override
  _ChatSearchDialogState createState() => _ChatSearchDialogState();
}

class _ChatSearchDialogState extends State<ChatSearchDialog> {
  final TextEditingController _controller = TextEditingController();
  List<String> _searchResults = [];
  bool _isLoading = false;

  void _onTextChanged(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final results = widget.onSearch(query);

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.slate900.withValues(alpha: 0.98),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10.r),
        side: BorderSide(color: AppColors.brandBlue.withValues(alpha: 0.25)),
      ),
      content: Padding(
        padding: EdgeInsetsGeometry.only(top: 20),
        child: SizedBox(
          width: 0.3.sw,
          height: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                prefixIcon: Icon(Icons.search),
                controller: _controller,
                hint: "Search chat",
                onChanged: _onTextChanged,
              ),
              const SizedBox(height: 15),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _searchResults.isEmpty && _controller.text.isNotEmpty
                    ? const Center(child: Text('No results found.'))
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final item = _searchResults[index];
                          final idx = item.indexOf(_controller.text);
                          return ListTile(
                            title: Text(
                              idx > -1
                                  ? item.replaceRange(
                                      0,
                                      item.indexOf(_controller.text),
                                      "...",
                                    )
                                  : item,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 6,
                            ),
                            onTap: () {
                              Navigator.of(context).pop(item);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            'Close',
            style: AppTextStyles.labelsmall.copyWith(
              color: AppColors.logoGradientEnd,
            ),
          ),
        ),
      ],
    );
  }
}
