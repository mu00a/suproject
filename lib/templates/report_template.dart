import 'package:flutter/material.dart';

class ReportTemplate extends StatefulWidget {
  const ReportTemplate({super.key});

  @override
  State<ReportTemplate> createState() => _ReportTemplateState();
}

class _ReportTemplateState extends State<ReportTemplate> {
  final _formKey = GlobalKey<FormState>();
  
  // متغيرات لحفظ البيانات
  final Map<String, TextEditingController> _controllers = {
    'title': TextEditingController(),
    'date': TextEditingController(),
    'executorName': TextEditingController(),
    'executionDate': TextEditingController(),
    'targetGroup': TextEditingController(),
    'count': TextEditingController(),
    'objective': TextEditingController(),
    'description': TextEditingController(),
  };

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                _buildHeaderSection(),
                _buildTitleSection(),
                _buildTableSection(),
                _buildFooterSection(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('قالب التقرير', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.deepPurple,
      actions: [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _saveReport,
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareReport,
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF666666),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildMinistryLogo(),
          const SizedBox(height: 10),
          const Text(
            'وزارة التعليم',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Ministry of Education',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinistryLogo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (index) => _buildDot()),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(9, (index) => _buildDot()),
          ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      margin: const EdgeInsets.all(2),
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInputRow('العنوان', _controllers['title']!),
          const SizedBox(height: 15),
          _buildInputRow('التاريخ', _controllers['date']!),
        ],
      ),
    );
  }

  Widget _buildInputRow(String label, TextEditingController controller) {
    return Row(
      children: [
        _buildLabel(label),
        const SizedBox(width: 10),
        Expanded(
          child: _buildInputField(
            controller: controller,
            hint: 'أدخل $label هنا',
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF666666),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.all(15),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }

  Widget _buildTableSection() {
    final fields = [
      {'label': 'اسم المنفذ', 'controller': _controllers['executorName']!, 'height': 50.0},
      {'label': 'تاريخ التنفيذ', 'controller': _controllers['executionDate']!, 'height': 50.0},
      {'label': 'الفئة المستهدفة', 'controller': _controllers['targetGroup']!, 'height': 50.0},
      {'label': 'العدد', 'controller': _controllers['count']!, 'height': 50.0},
      {'label': 'الهدف', 'controller': _controllers['objective']!, 'height': 130.0},
      {'label': 'الوصف', 'controller': _controllers['description']!, 'height': 130.0},
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Table(
        border: TableBorder.all(color: Colors.grey),
        children: fields.map((field) => _buildTableRow(
          field['label'] as String,
          field['controller'] as TextEditingController,
          height: field['height'] as double,
        )).toList(),
      ),
    );
  }

  TableRow _buildTableRow(String label, TextEditingController controller, {required double height}) {
    return TableRow(
      children: [
        Container(
          height: height,
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            controller: controller,
            maxLines: null,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'هذا الحقل مطلوب';
              }
              return null;
            },
          ),
        ),
        Container(
          height: height,
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildEvidenceSection(),
          const SizedBox(height: 30),
          _buildSignatureSection(),
        ],
      ),
    );
  }

  Widget _buildEvidenceSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
          decoration: BoxDecoration(
            color: const Color(0xFF666666),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text(
            'الشواهد',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _pickEvidence,
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('إضافة شواهد'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildSignatureSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSignatureBox('مدير المدرسة'),
        _buildSignatureBox('منفذ التقرير'),
      ],
    );
  }

  Widget _buildSignatureBox(String title) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text('التوقيع:'),
          const SizedBox(height: 30),
          Container(
            height: 1,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _generatePDF,
      icon: const Icon(Icons.picture_as_pdf),
      label: const Text('تصدير PDF'),
      backgroundColor: Colors.deepPurple,
    );
  }

  void _saveReport() {
    if (_formKey.currentState?.validate() ?? false) {
      // حفظ التقرير
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ التقرير بنجاح')),
      );
    }
  }

  void _shareReport() {
    // مشاركة التقرير
  }

  void _pickEvidence() async {
    // اختيار الشواهد
  }

  void _generatePDF() {
    // توليد ملف PDF
  }
}