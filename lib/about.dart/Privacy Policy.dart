import 'package:flutter/material.dart';
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Privacy Policy")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
نحن نحترم خصوصيتك، وفيما يلي شرح لطريقة جمع واستخدام بياناتك:

1. نقوم بجمع البيانات الأساسية مثل الاسم، البريد الإلكتروني، رقم الهاتف، وتاريخ الميلاد لتقديم الخدمة.

2. يتم استخدام بياناتك لتحسين جودة الخدمة وتخصيص التجربة داخل التطبيق.

3. لا نقوم بمشاركة معلوماتك مع أي طرف ثالث بدون إذنك، إلا إذا تطلب القانون ذلك.

4. جميع البيانات يتم تخزينها بشكل آمن وفقًا لأحدث المعايير.

5. يحق لك طلب حذف حسابك وجميع بياناتك في أي وقت من خلال الإعدادات أو التواصل معنا.

6. باستخدامك لهذا التطبيق، فإنك توافق على سياسة الخصوصية هذه.
            ''',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
