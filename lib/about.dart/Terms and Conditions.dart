
import 'package:flutter/material.dart';
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Terms and Conditions")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
1. استخدامك لهذا التطبيق يعني موافقتك على جميع الشروط والأحكام المدرجة.

2. التطبيق مخصص لتقديم استشارات طبية أولية فقط، ولا يغني عن زيارة الطبيب المختص عند الحاجة.

3. يُمنع استخدام التطبيق لأي أغراض غير قانونية أو ضارة.

4. تحتفظ إدارة التطبيق بحق تعديل هذه الشروط في أي وقت دون إشعار مسبق.

5. المستخدم مسؤول عن دقة البيانات الشخصية المُدخلة خلال عملية التسجيل.

6. قد تتطلب بعض الخدمات رسومًا إضافية حسب ما هو موضح داخل التطبيق.

7. جميع المحتويات داخل التطبيق محمية بموجب حقوق النشر ولا يجوز نسخها أو إعادة توزيعها.
            ''',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
