import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/gallery_provider.dart';
import '../../models/artwork.dart';
import '../../widgets/show_custom_dialog.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  File? _imageFile;
  String? _webImageUrl;
  String? _previewTitle;
  String? _previewDesc;
  File? _previewImage;
  final bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        setState(() {
          _webImageUrl = picked.path;
          _imageFile = null;
        });
      } else {
        setState(() {
          _imageFile = File(picked.path);
          _webImageUrl = null;
        });
      }
    }
  }

  void _updatePreview() {
    if (!_formKey.currentState!.validate() ||
        (_imageFile == null &&
            (_webImageUrl == null || _webImageUrl!.isEmpty))) {
      return;
    }
    setState(() {
      _previewTitle = _titleController.text;
      _previewDesc = _descController.text;
      _previewImage = _imageFile;
    });
    // No confirmation dialog for preview update as per user request
  }

  void _submitArtwork(BuildContext context) {
    if (_previewTitle == null ||
        _previewDesc == null ||
        (_previewImage == null &&
            (_webImageUrl == null || _webImageUrl!.isEmpty))) {
      showCustomDialog(
        context: context,
        message: 'Please update the preview first.',
      );
      return;
    }
    final gallery = Provider.of<GalleryProvider>(context, listen: false);
    final user = gallery.user;
    final artwork = Artwork(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _previewTitle!,
      description: _previewDesc!,
      imagePath: kIsWeb ? (_webImageUrl ?? '') : (_previewImage?.path ?? ''),
      artistName: user.name,
      createdAt: DateTime.now(),
    );
    gallery.uploadArtwork(artwork);
    showCustomDialog(
      context: context,
      message: 'Artwork uploaded!',
    );
    setState(() {
      _previewTitle = null;
      _previewDesc = null;
      _previewImage = null;
      _imageFile = null;
      _webImageUrl = null;
      _titleController.clear();
      _descController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Artwork')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: (kIsWeb
                        ? (_webImageUrl == null || _webImageUrl!.isEmpty)
                        : _imageFile == null)
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Tap to upload artwork image',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          if (kIsWeb &&
                              _webImageUrl != null &&
                              _webImageUrl!.isNotEmpty)
                            Image.network(_webImageUrl!, fit: BoxFit.cover)
                          else if (!kIsWeb && _imageFile != null)
                            Image.file(_imageFile!, fit: BoxFit.cover),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              color: Colors.black54,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: const Text('Tap to change image',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter a title' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter a description' : null,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isUploading ? null : _updatePreview,
                    icon: const Icon(Icons.visibility),
                    label: Text(_isUploading
                        ? 'Updating Preview...'
                        : 'Update Preview'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (((kIsWeb && _webImageUrl != null && _webImageUrl!.isNotEmpty) ||
                    (!kIsWeb && _previewImage != null)) &&
                _previewTitle != null &&
                _previewDesc != null)
              Column(
                children: [
                  Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8)),
                          child: kIsWeb &&
                                  _webImageUrl != null &&
                                  _webImageUrl!.isNotEmpty
                              ? Image.network(_webImageUrl!,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover)
                              : (!kIsWeb && _previewImage != null)
                                  ? Image.file(_previewImage!,
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover)
                                  : const SizedBox.shrink(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_previewTitle!,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 4),
                              Text(_previewDesc!,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _submitArtwork(context),
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Submit Artwork'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
