import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TemplatePage extends StatefulWidget {
  final String imagePath;

  const TemplatePage({super.key, required this.imagePath});

  @override
  TemplatePageState createState() => TemplatePageState();
}

class TemplatePageState extends State<TemplatePage> {
  final GlobalKey _globalKey = GlobalKey();

  final double imageWidth = 595.0;
  final double imageHeight = 842.0;

  final List<File?> _selectedImages =
      List.filled(6, null); // الصور المضافة في المربعات
  final List<File> _educationImages = []; // الصور المضافة في الزر السفلي
  bool _isLoading = false;
  bool _isExporting = false;

  late final Map<String, double> addEducationImageButtonPosition;
  late final Map<String, double> educationImagePosition;

  // إحداثيات الصور الستة
  final List<Map<String, double>> imagePositions = [
    // الصور العلوية
    {"top": 292.0, "left": 40.0}, // الصورة الأولى في الأعلى
    {"top": 292.0, "left": 140.0}, // الصورة الثانية في الأعلى
    {"top": 292.0, "left": 240.0}, // الصورة الثالثة في الأعلى

    // الصور السفلية
    {"top": 386.0, "left": 40.0}, // الصورة الأولى في الأسفل
    {"top": 386.0, "left": 140.0}, // الصورة الثانية في الأسفل
    {"top": 386.0, "left": 240.0}, // الصورة الثالثة في الأسفل
  ];

  // حجم الصور
  final double imageSize = 85; // حجم الصورة (العرض والارتفاع)

  late final List<TextEditingController> controllers;
  late final List<FocusNode> focusNodes;

  final ScrollController _scrollController = ScrollController();

  double _zoomLevel = 1.0;
  double _offsetX = 0.0;

  @override
  void initState() {
    super.initState();

    addEducationImageButtonPosition = {
      "top": 14,
      "left": 10,
    };

    educationImagePosition = {
      "top": addEducationImageButtonPosition["top"]!,
      "left": addEducationImageButtonPosition["left"]! + 20,
    };

    controllers = List.generate(
      11,
      (index) => TextEditingController(
          text: [
        "اسم المدرسة",
        "إدارة التعليم",
        "العنوان",
        "التاريخ",
        "الفئة",
        "العدد",
        "المنفذ",
        "الأهداف",
        "الوصف",
        "مدير المدرسة",
        "اسم المنفذ"
      ][index]),
    );

    focusNodes = List.generate(11, (index) => FocusNode());

    for (int i = 0; i < focusNodes.length; i++) {
      focusNodes[i].addListener(() {
        if (focusNodes[i].hasFocus && (i == 7 || i == 8)) {
          setState(() {
            _zoomLevel = 1.5;
            _offsetX = MediaQuery.of(context).size.width * 0.4;
          });
        } else {
          setState(() {
            _zoomLevel = 1.0;
            _offsetX = 0.0;
          });
        }
      });
    }

    // إضافة listener لحفظ النصوص تلقائيًا
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(() async {
        await _saveText(i);
      });
    }

    _loadSavedData();
  }

  List<Map<String, dynamic>> getTextPositions() {
    return [
      {
        "top": 0.039369772491092636,
        "left": 0.03914382878151268,
        "fontSize": 10.0,
        "color": const ui.Color.fromARGB(255, 253, 253, 253),
        "maxLength": null,
      },
      {
        "top": -0.01225067436163896,
        "left": -0.07745871848739495,
        "fontSize": 9.0,
        "color": const ui.Color.fromARGB(255, 252, 250, 250),
        "maxLength": 80,
      },
      {
        "top": 0.10619804223574822,
        "left": 0.07417528886554621,
        "fontSize": 10.0,
        "color": const ui.Color.fromARGB(255, 248, 248, 248),
        "maxLength": null,
      },
      {
        "top": 0.18530869210213774,
        "left": 0.09954128151260497,
        "fontSize": 10.0,
        "color": Colors.black,
        "maxLength": 30,
      },
      {
        "top": 0.2188212997327791,
        "left": 0.09953416491596642,
        "fontSize": 10.0,
        "color": Colors.black,
        "maxLength": 40,
      },
      {
        "top": 0.25296695368171023,
        "left": 0.0995341649159664,
        "fontSize": 10.0,
        "color": Colors.black,
        "maxLength": 30,
      },
      {
        "top": 0.15586499591745845,
        "left": 0.09992959558823527,
        "fontSize": 10.0,
        "color": Colors.black,
        "maxLength": 30,
      },
      {
        "top": 0.15830086104513057,
        "left": -0.1299886817226891,
        "fontSize": 9.0,
        "color": Colors.black,
        "maxLength": null,
      },
      {
        "top": 0.2199925994695982,
        "left": -0.13002014180672255,
        "fontSize": 8.0,
        "color": Colors.black,
        "maxLength": null,
      },
      {
        "top": 0.5435428351395502,
        "left": -0.1505125787815125,
        "fontSize": 9.0,
        "color": Colors.black,
        "maxLength": 36,
      },
      {
        "top": 0.5441613160629469,
        "left": 0.17022352941176444,
        "fontSize": 9.0,
        "color": Colors.black,
        "maxLength": 36,
      },
    ];
  }

  Future<void> exportToImage() async {
    try {
      setState(() {
        _isExporting = true;
      });

      await Future.delayed(const Duration(milliseconds: 100));

      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      // زيادة دقة الصورة
      ui.Image image = await boundary.toImage(pixelRatio: 8.0);

      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/exported_template.png');

      await file.writeAsBytes(pngBytes);

      // ضغط الصورة مع الحفاظ على الجودة
      final compressedImage = await _compressImage(file, quality: 95);

      if (!mounted) return;

      await Share.shareXFiles([XFile(compressedImage.path)],
          text: '📄 تقريرك جاهز');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ خطأ أثناء تصدير الصورة: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  Widget _buildEditableText(TextEditingController controller, FocusNode node,
      Map<String, dynamic> position) {
    return Positioned(
      top: position["top"]! * imageHeight,
      left: position["left"]! * imageWidth,
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(5.0),
        child: TextField(
          controller: controller,
          focusNode: node,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          maxLines: null,
          maxLength: position["maxLength"],
          style: TextStyle(
            fontSize: position["fontSize"],
            fontWeight: FontWeight.bold,
            color: position["color"],
            fontFamily: 'Amiri',
            height: 1.2,
          ),
          cursorColor: Colors.black,
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: "",
          ),
        ),
      ),
    );
  }

  Future<File> _compressImage(File file, {int quality = 95}) async {
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        "${file.absolute.path}_compressed.png",
        quality: quality,
      );

      if (result == null) {
        throw Exception("فشل في ضغط الصورة");
      }

      return File(result.path);
    } catch (e) {
      debugPrint("خطأ أثناء ضغط الصورة: $e");
      return file;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textPositions = getTextPositions();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('تحرير القالب'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share), // تغيير الأيقونة إلى مشاركة
            tooltip: "مشاركة القالب",
            onPressed: exportToImage,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Center(
                child: RepaintBoundary(
                  key: _globalKey,
                  child: Transform.translate(
                    offset: Offset(_offsetX, 0),
                    child: Transform.scale(
                      scale: _zoomLevel,
                      child: AspectRatio(
                        aspectRatio: 1 / 1.414,
                        child: Container(
                          width: imageWidth,
                          height: imageHeight,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // الخلفية مع FittedBox
                              Positioned.fill(
                                child: FittedBox(
                                  fit: BoxFit.contain, // ضبط الخلفية دون تمدد
                                  child: Image.asset(
                                    widget.imagePath,
                                    width: imageWidth, // تحديد العرض
                                    height: imageHeight, // تحديد الارتفاع
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              for (int i = 0; i < textPositions.length; i++)
                                _buildEditableText(controllers[i],
                                    focusNodes[i], textPositions[i]),
                              ..._buildImageWidgets(),
                              ..._buildEducationImageWidgets(),
                              if (!_isExporting)
                                Positioned(
                                  top: addEducationImageButtonPosition["top"]!,
                                  left:
                                      addEducationImageButtonPosition["left"]!,
                                  child: GestureDetector(
                                    onTap: _pickEducationImage,
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(Icons.add,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _saveData,
            child: const Text("حفظ التعديلات", style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildImageWidgets() {
    List<Widget> widgets = [];

    for (int i = 0; i < 6; i++) {
      // 6 مربعات للصور
      double top = imagePositions[i]["top"]!;
      double left = imagePositions[i]["left"]!;

      if (!_isExporting) {
        widgets.add(
          Positioned(
            top: top,
            left: left,
            child: GestureDetector(
              onTap: () => _pickImage(i), // اختيار صورة عند النقر على المربع
              child: Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // إطار المربع
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _selectedImages[i] != null
                    ? Stack(
                        children: [
                          Image.file(
                            _selectedImages[i]!,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _deleteImage(i),
                            ),
                          ),
                        ],
                      )
                    : const Icon(Icons.add,
                        color: Colors.grey), // أيقونة إضافة صورة
              ),
            ),
          ),
        );
      } else if (_selectedImages[i] != null) {
        // عند التصدير، إظهار الصور فقط دون المربعات
        widgets.add(
          Positioned(
            top: top,
            left: left,
            child: SizedBox(
              width: imageSize,
              height: imageSize,
              child: Image.file(
                _selectedImages[i]!,
                fit: BoxFit.contain, // الحفاظ على حجم الصورة دون قصها
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  List<Widget> _buildEducationImageWidgets() {
    List<Widget> widgets = [];
    double imageSize = 45;

    for (int i = 0; i < _educationImages.length; i++) {
      double top = educationImagePosition["top"]!;
      double left = educationImagePosition["left"]!;

      widgets.add(
        Positioned(
          top: top,
          left: left,
          child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: Stack(
              children: [
                Image.file(
                  _educationImages[i],
                  fit: BoxFit.cover,
                ),
                if (!_isExporting)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => _deleteEducationImage(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  void _deleteImage(int index) {
    if (!mounted) return;
    setState(() {
      _selectedImages[index] = null;
    });
  }

  void _deleteEducationImage(int index) {
    if (!mounted) return;
    setState(() {
      _educationImages.removeAt(index);
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final templateKey = widget.imagePath;

    // حفظ النصوص فقط
    for (int i = 0; i < controllers.length; i++) {
      prefs.setString('${templateKey}text$i', controllers[i].text);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم الحفظ بنجاح')),
      );
    }
  }

  Future<void> _saveText(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final templateKey = widget.imagePath;
    prefs.setString('${templateKey}text$index', controllers[index].text);
  }

  Future<File> _base64ToImage(String base64String) async {
    final bytes = base64Decode(base64String);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/temp_image.png');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final templateKey = widget.imagePath;

    for (int i = 0; i < controllers.length; i++) {
      final savedText = prefs.getString('${templateKey}text$i');
      if (savedText != null) {
        controllers[i].text = savedText;
      }
    }

    final savedImagesCount =
        prefs.getInt('${templateKey}_saved_images_count') ?? 0;
    for (int i = 0; i < savedImagesCount; i++) {
      final imageBase64 = prefs.getString('${templateKey}image$i');
      if (imageBase64 != null) {
        final imageFile = await _base64ToImage(imageBase64);
        _selectedImages[i] = imageFile;
      }
    }

    final savedEducationImagesCount =
        prefs.getInt('${templateKey}_saved_education_images_count') ?? 0;
    for (int i = 0; i < savedEducationImagesCount; i++) {
      final imageBase64 = prefs.getString('${templateKey}education_image$i');
      if (imageBase64 != null) {
        final imageFile = await _base64ToImage(imageBase64);
        _educationImages.add(imageFile);
      }
    }

    setState(() {});
  }

  Future<void> _pickImage(int index) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final File compressedImage = await _compressImage(File(image.path));
        if (mounted) {
          setState(() {
            _selectedImages[index] =
                compressedImage; // إضافة الصورة في المربع المحدد
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ خطأ أثناء اختيار الصورة: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickEducationImage() async {
    try {
      if (_educationImages.isNotEmpty) {
        // يسمح بإضافة صورة واحدة فقط
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ يمكنك إضافة صورة واحدة فقط')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final File compressedImage = await _compressImage(File(image.path));
        if (mounted) {
          setState(() {
            _educationImages.add(compressedImage);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ خطأ أثناء اختيار الصورة: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

