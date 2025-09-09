import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../controllers/otp_controller.dart';
import '../../services/auth_service.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({
    super.key,
    required this.identifier,
    required this.auth,
  });

  final String identifier;   // إيميل/جوال
  final AuthService auth;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  late final OtpController c;
  final _otpCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    c = OtpController(auth: widget.auth, identifier: widget.identifier);
  }

  @override
  void dispose() {
    c.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  String _mmss(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _verify([String? code]) async {
    final otp = (code ?? _otpCtrl.text).trim();
    if (otp.length < 4) return;
    final ok = await c.submitOtp(otp);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم التحقق بنجاح')),
      );
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP غير صحيح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final purple = const Color(0xFF6C44F6);

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 56,
      textStyle: theme.textTheme.titleLarge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E6E6)),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            color: Color(0x11000000),
          )
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: purple, width: 2),
    );

    final submittedPinTheme =
    defaultPinTheme.copyDecorationWith(border: Border.all(color: purple));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7FB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Text(
                'Verification',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We've sent you a 6-digit verification code to your mobile number",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _mask(widget.identifier),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 24),

              // OTP input
              Pinput(
                length: 6,
                controller: _otpCtrl,
                keyboardType: TextInputType.number,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                separatorBuilder: (index) => const SizedBox(width: 12),
                onCompleted: _verify,
              ),

              const SizedBox(height: 16),

              // Countdown
              ValueListenableBuilder<int>(
                valueListenable: c.secondsLeft,
                builder: (_, s, __) => Text(
                  'Code expires in ${_mmss(s)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 6),

              // Resend
              ValueListenableBuilder<bool>(
                valueListenable: c.canResend,
                builder: (_, can, __) => InkWell(
                  onTap: can ? () => c.resend() : null,
                  child: Text(
                    'Resend Code',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: can ? purple : Colors.grey,
                      fontWeight: FontWeight.w700,
                      decoration:
                      can ? TextDecoration.underline : TextDecoration.none,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Verify button
              ValueListenableBuilder<bool>(
                valueListenable: c.isLoading,
                builder: (_, loading, __) => SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: loading ? null : _verify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: loading
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text(
                      'Verify',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _mask(String v) {
    // لو رقم جوال: اخفي كل الأرقام عدا أول 2 وآخر 2
    final isPhone = RegExp(r'^\+?\d{7,15}$').hasMatch(v);
    if (isPhone) {
      if (v.length <= 4) return v;
      final start = v.substring(0, 2);
      final end = v.substring(v.length - 2);
      return '$start ${'•' * 3} ${'•' * 3} $end';
    }
    // لو بريد: اخفي الجزء قبل @
    final i = v.indexOf('@');
    if (i > 1) {
      return '${v[0]}***${v.substring(i)}';
    }
    return v;
  }
}
