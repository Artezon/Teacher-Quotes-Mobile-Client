import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../styles/theme.dart';

class FacultyInfoPage extends StatelessWidget {
  const FacultyInfoPage({super.key});

  final String title = 'Информация';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Material(
              elevation: 2.0,
              child: Container(
                color: Colors.grey[200],
                padding: AppStyles.horizontalPadding.copyWith(
                  top: 16,
                  bottom: 16,
                ),
                width: double.infinity,
                child: Text(
                  'Факультет компьютерных технологий и прикладной математики',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
            ),
            Padding(
              padding: AppStyles.horizontalPadding.copyWith(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLinkSection(
                    context,
                    'Ссылка на факультет',
                    'https://vk.com/fktipm_kubsu',
                  ),
                  _buildInfoSection(
                    context,
                    'Адрес',
                    '350040, г. Краснодар, ул. Ставропольская, 149',
                  ),
                  _buildPhoneSection(context),
                  _buildEmailSection(
                    context,
                    'Электронная почта',
                    'fpm@kubsu.ru',
                  ),
                  _buildListSection('Преподаватели', [
                    'Иванов И.И.',
                    'Петров П.П.',
                    'Сидоров С.С.',
                  ]),
                  _buildListSection('Дисциплины', [
                    'Дискретная математика',
                    'Инструменты проектирования ИС',
                    'Комбинаторный анализ',
                    'Криптографические протоколы',
                    'Нейросетевые и нечёткие модели',
                    'Нечеткий анализ и моделирование',
                    'Паттерны программирования',
                  ]),
                  _buildStatsSection(),
                  _buildInfoSection(
                    context,
                    'Дата последней публикации',
                    '10.02.2025',
                  ),
                  const SizedBox(height: 24),
                  _buildQuoteButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneSection(BuildContext context) {
    const phones = [
      '+7 (861) 219-95-78 (деканат)',
      '+7 (918) 193-20-23 (деканат)',
    ];

    return Padding(
      padding: AppStyles.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Телефон:', style: AppStyles.sectionTitle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                phones
                    .map((phone) => _buildClickablePhone(context, phone))
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildClickablePhone(BuildContext context, String phone) {
    return GestureDetector(
      onTap: () => _launchUrl('tel:${_cleanPhone(phone)}'),
      onLongPress: () => _copyWithSnackbar(context, phone),
      child: Text(phone, style: AppStyles.linkText),
    );
  }

  String _cleanPhone(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9+]'), '');
  }

  Widget _buildLinkSection(BuildContext context, String title, String value) {
    return Padding(
      padding: AppStyles.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title + ':', style: AppStyles.sectionTitle),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _launchUrl(value),
            onLongPress: () => _copyWithSnackbar(context, value),
            child: Text(value, style: AppStyles.linkText),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailSection(BuildContext context, String title, String email) {
    return Padding(
      padding: AppStyles.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title + ':', style: AppStyles.sectionTitle),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _launchUrl('mailto:$email'),
            onLongPress: () => _copyWithSnackbar(context, email),
            child: Text(email, style: AppStyles.linkText),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, String value) {
    return Padding(
      padding: AppStyles.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title + ':', style: AppStyles.sectionTitle),
          const SizedBox(height: 8),
          GestureDetector(
            onLongPress: () => _copyWithSnackbar(context, value),
            child: Text(value, style: AppStyles.regularText),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection(String title, List<String> items) {
    return Padding(
      padding: AppStyles.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title + ':', style: AppStyles.sectionTitle),
          const SizedBox(height: 8),
          ...items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $item', style: AppStyles.regularText),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: AppStyles.cardPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Количество цитат:', style: AppStyles.sectionTitle),
                const SizedBox(height: 4),
                Text('243', style: AppStyles.regularText),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Количество реакций:', style: AppStyles.sectionTitle),
                const SizedBox(height: 4),
                Text('5437', style: AppStyles.regularText),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text('Перейти к цитатам'),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  void _copyWithSnackbar(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(msg: 'Скопировано: $text');
  }
}
