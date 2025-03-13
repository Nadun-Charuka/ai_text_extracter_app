import 'package:ai_text_extracter_app/provider/premium_provider.dart';
import 'package:ai_text_extracter_app/widgets/show_premium_form.dart';
import 'package:ai_text_extracter_app/widgets/user_history_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserHistoryPage extends StatelessWidget {
  const UserHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isPremiumProvider = Provider.of<PremiumProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      isPremiumProvider.checkPremiumStatus();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "History Conversions",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          isPremiumProvider.isPremium
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.star,
                    color: Colors.amberAccent,
                  ),
                )
              : SizedBox()
        ],
      ),
      body: isPremiumProvider.isPremium
          ? const UserHistoryWidget() // Load only the history content
          : const ShowPremiumPannel(),
    );
  }
}
