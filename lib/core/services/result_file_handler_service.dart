import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:radiology_and_lab_app/shared/widgets/app_snackbar.dart';

class ResultFileHandlerService {
  static bool isPdf(String urlOrPath) {
    final lower = urlOrPath.toLowerCase();
    return lower.endsWith('.pdf');
  }

  static bool isImage(String urlOrPath) {
    final lower = urlOrPath.toLowerCase();
    return lower.endsWith('.jpg') || lower.endsWith('.jpeg') || lower.endsWith('.png');
  }

  static IconData getIconForFile(String url) {
    if (isPdf(url)) return Icons.picture_as_pdf;
    if (isImage(url)) return Icons.image;
    return Icons.insert_drive_file;
  }

  static Color getColorForFile(String url) {
    if (isPdf(url)) return Colors.red;
    if (isImage(url)) return Colors.blue;
    return Colors.grey;
  }

  static Future<void> openOrDownloadFile(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          AppSnackBar.showError(context, 'Could not open file');
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.showError(context, 'Error opening file: $e');
      }
    }
  }

  static Future<void> previewFile(BuildContext context, String url) async {
    if (isPdf(url)) {
      // For PDF, open externally
      await openOrDownloadFile(context, url);
    } else if (isImage(url)) {
      // For Image, show a dialog preview
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 300,
                          height: 300,
                          color: Colors.white,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                              color: const Color(0xFF0D9488),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 300,
                          height: 300,
                          color: Colors.white,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              SizedBox(height: 10),
                              Text('Failed to load image', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      // Fallback
      await openOrDownloadFile(context, url);
    }
  }
}
