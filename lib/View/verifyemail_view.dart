import 'package:flutter/material.dart';
import 'package:flutter_application_codebootcamp/Constance/routes.dart';
import 'package:flutter_application_codebootcamp/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('驗鎮信箱'),
      ),
      body: Column(
        children: [
          const Text('註冊信已寄出'),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text('沒有收到信件? 點我發送信件')),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                //await FirebaseAuth.instance.signOut();
                Navigator.of(this.context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('回到註冊頁'))
        ],
      ),
    );
  }
}
