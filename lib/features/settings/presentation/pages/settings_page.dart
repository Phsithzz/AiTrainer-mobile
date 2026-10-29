import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/constants/app_colors.dart';
import 'package:mobile/core/di/injection_container.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/widgets/app_card.dart';
import 'package:mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:mobile/features/auth/presentation/bloc/auth_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _voiceFeedback = true;
  bool _vibrationFeedback = true;

  @override
  Widget build(BuildContext context) {
    final apiClient = sl<ApiClient>();
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;
    final isMock = authState is Authenticated
        ? authState.isMock
        : (authState is Unauthenticated ? authState.isMock : apiClient.isMockMode());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ตั้งค่า & โปรไฟล์'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card
          AppCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  child: Text(
                    user != null && user.username.isNotEmpty
                        ? user.username[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.username ?? 'ผู้ใช้งาน',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email.isNotEmpty == true ? user!.email : 'บัญชีสมาชิก',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ยืนยันตัวตนแล้ว',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Workout Settings
          const Text(
            'การแจ้งเตือนการออกกำลังกาย',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('เสียงแนะนำท่าทาง (Voice Cue)'),
                  subtitle: const Text('เตือนเมื่อทำท่าผิด เช่น ส้นเท้าลอย, สะโพกตก'),
                  value: _voiceFeedback,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() => _voiceFeedback = val);
                  },
                ),
                const Divider(height: 1, color: AppColors.divider),
                SwitchListTile(
                  title: const Text('ระบบสั่นเตือน (Haptic Feedback)'),
                  subtitle: const Text('สั่นเมื่อนับครั้งสำเร็จหรือท่าทางผิดพลาด'),
                  value: _vibrationFeedback,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() => _vibrationFeedback = val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Network & Server Settings
          const Text(
            'การเชื่อมต่อเซิร์ฟเวอร์',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.dns_outlined, color: AppColors.primary),
                  title: const Text('Backend API Host'),
                  subtitle: Text(apiClient.getBaseUrl()),
                  trailing: const Icon(Icons.edit, size: 18, color: AppColors.textSecondary),
                  onTap: () => _showEditBaseUrlDialog(context, apiClient),
                ),
                const Divider(height: 1, color: AppColors.divider),
                SwitchListTile(
                  secondary: const Icon(Icons.science_outlined, color: AppColors.accent),
                  title: const Text('Mock Mode (โหมดจำลอง)'),
                  subtitle: const Text('ทดสอบระบบโดยไม่ต้องต่อ AI Server จริง'),
                  value: isMock,
                  activeThumbColor: AppColors.accent,
                  onChanged: (val) {
                    context.read<AuthBloc>().add(SwitchMockModeEvent(val));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          val ? 'เปิดโหมด Mock สำเร็จ' : 'ปิดโหมด Mock (เชื่อมต่อ API จริง)',
                        ),
                        backgroundColor: val ? AppColors.accent : AppColors.primary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // About
          const Text(
            'เกี่ยวกับแอปพลิเคชัน',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          AppCard(
            child: Column(
              children: [
                _buildInfoRow('เวอร์ชัน', '1.0.0 (Build 1)'),
                const Divider(height: 16, color: AppColors.divider),
                _buildInfoRow('สถาปัตยกรรม', 'Flutter BLoC + Clean Architecture'),
                const Divider(height: 16, color: AppColors.divider),
                _buildInfoRow('AI Backend', 'FastAPI + MediaPipe Pose Tracker'),
                const Divider(height: 16, color: AppColors.divider),
                _buildInfoRow('ท่าทางที่รองรับ', 'Squat, Push-up, Plank'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () => _confirmLogout(context),
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: const Text('ออกจากระบบ', style: TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  void _showEditBaseUrlDialog(BuildContext context, ApiClient client) {
    final controller = TextEditingController(text: client.getBaseUrl());
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('แก้ไข Backend API URL'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'กรอก IP / Host ของเครื่องรัน FastAPI:',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'http://192.168.1.X:8000',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newUrl = controller.text.trim();
              if (newUrl.isNotEmpty) {
                await client.setBaseUrl(newUrl);
                if (mounted) setState(() {});
              }
              if (dialogCtx.mounted) Navigator.pop(dialogCtx);
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('ยืนยันการออกจากระบบ'),
        content: const Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<AuthBloc>().add(LogoutRequestedEvent());
            },
            child: const Text('ออกจากระบบ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
