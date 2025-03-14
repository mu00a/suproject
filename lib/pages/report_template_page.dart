import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportTemplatePage extends StatefulWidget {
  const ReportTemplatePage({super.key});

  @override
  State<ReportTemplatePage> createState() => _ReportTemplatePageState();
}

class _ReportTemplatePageState extends State<ReportTemplatePage> {
  // التحكم في حقول النص
  final TextEditingController _schoolNameController = TextEditingController(text: "اسم المدرسة");
  final TextEditingController _addressController = TextEditingController(text: "العنوان");
  final TextEditingController _goalsController = TextEditingController(text: "الأهداف");
  final TextEditingController _descriptionController = TextEditingController(text: "الوصف");
  final TextEditingController _executorNameController = TextEditingController(text: "اسم المنفذ");
  final TextEditingController _executionDateController = TextEditingController(text: "تاريخ التنفيذ");
  final TextEditingController _targetGroupController = TextEditingController(text: "الفئة المستهدفة");
  final TextEditingController _countController = TextEditingController(text: "العدد");
  final TextEditingController _schoolManagerController = TextEditingController(text: "مدير المدرسة");

  // قائمة لتخزين الصور المختارة
  final List<File?> _selectedImages = List.filled(6, null);

  // دالة لاختيار صورة جديدة
  Future<void> _pickImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _selectedImages[index] = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحرير القالب'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: "مشاركة القالب",
            onPressed: () {},
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // تعيين اتجاه النص من اليمين إلى اليسار
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // الجزء العلوي - شعار وزارة التعليم واسم المدرسة
              _buildHeaderSection(),
              
              const SizedBox(height: 20),
              
              // الجزء الأوسط - العنوان والمعلومات الرئيسية
              _buildMainInfoSection(),
              
              const SizedBox(height: 20),
              
              // قسم الشواهد
              _buildEvidenceSection(),
              
              const SizedBox(height: 20),
              
              // التوقيعات في الأسفل
              _buildSignatureSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حفظ التعديلات بنجاح')),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Colors.deepPurple,
            ),
            child: const Text(
              "حفظ التعديلات",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // بناء الجزء العلوي
  Widget _buildHeaderSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          // شعار وزارة التعليم
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image/ministry_logo.png', // استبدل هذا بمسار شعار الوزارة الحقيقي
                width: 120,
                height: 80,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 80,
                    alignment: Alignment.center,
                    color: Colors.grey.shade300,
                    child: const Text(
                      'وزارة التعليم\nMinistry of Education',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // اسم المدرسة
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: _schoolNameController,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // بناء قسم المعلومات الرئيسية
  Widget _buildMainInfoSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العمود الأول - العنوان
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _addressController,
              maxLines: 2,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: "العنوان",
                labelStyle: TextStyle(color: Colors.grey.shade700),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // العمود الثاني والثالث
        Expanded(
          flex: 3,
          child: Column(
            children: [
              // صف 1: الهدف واسم المنفذ
              _buildInfoRow("الهدف", _goalsController, "اسم المنفذ", _executorNameController),
              const SizedBox(height: 16),
              // صف 2: الوصف وتاريخ التنفيذ
              _buildInfoRow("الوصف", _descriptionController, "تاريخ التنفيذ", _executionDateController),
              const SizedBox(height: 16),
              // صف 3: فارغ والفئة المستهدفة
              _buildInfoRow("", TextEditingController(), "الفئة المستهدفة", _targetGroupController),
              const SizedBox(height: 16),
              // صف 4: فارغ والعدد
              _buildInfoRow("", TextEditingController(), "العدد", _countController),
            ],
          ),
        ),
      ],
    );
  }

  // بناء صف من المعلومات
  Widget _buildInfoRow(String label1, TextEditingController controller1, String label2, TextEditingController controller2) {
    return Row(
      children: [
        if (label1.isNotEmpty)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label1,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    controller: controller1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (label1.isNotEmpty) const SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label2,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: controller2,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // بناء قسم الشواهد
  Widget _buildEvidenceSection() {
    return Column(
      children: [
        // عنوان قسم الشواهد
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "الشواهد",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // مربعات اختيار الصور
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _pickImage(index),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedImages[index] != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.file(
                            _selectedImages[index]!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImages[index] = null;
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Icon(
                      Icons.add,
                      size: 40,
                      color: Colors.grey,
                    ),
              ),
            );
          },
        ),
      ],
    );
  }

  // بناء قسم التوقيعات
  Widget _buildSignatureSection() {
    return Row(
      children: [
        // مدير المدرسة
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "مدير المدرسة",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _schoolManagerController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // اسم المنفذ
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "اسم المنفذ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _executorNameController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}