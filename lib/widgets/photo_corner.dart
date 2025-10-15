import 'package:bimta/services/profile/photo_profil.dart';
import 'package:flutter/material.dart';

class PhotoCorner extends StatefulWidget {
  final double height;
  final double width;
  final bool enableNavigation;

  const PhotoCorner({
    super.key,
    required this.height,
    required this.width,
    this.enableNavigation = true,
  });

  @override
  State<PhotoCorner> createState() => PhotoCornerState();
}

class PhotoCornerState extends State<PhotoCorner> {
  final ProfileService _profileService = ProfileService();
  String? _photoUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPhotoProfile();
  }

  Future<void> _loadPhotoProfile() async {
    try {
      final photoUrl = await _profileService.getPhotoUrl();
      if (mounted) {
        setState(() {
          _photoUrl = photoUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading photo profile: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Method untuk refresh foto dari parent widget
  Future<void> refreshPhoto() async {
    setState(() {
      _isLoading = true;
    });
    await _loadPhotoProfile();
  }

  @override
  Widget build(BuildContext context) {
    Widget photoWidget = Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.grey[300],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: _isLoading
            ? Center(
          child: SizedBox(
            height: widget.height * 0.4,
            width: widget.width * 0.4,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.grey[600],
            ),
          ),
        )
            : _photoUrl != null && _photoUrl!.isNotEmpty
            ? Image.network(
          _photoUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              "assets/images/avatar.png",
              fit: BoxFit.cover,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
                color: Colors.grey[600],
              ),
            );
          },
        )
            : Image.asset(
          "assets/images/avatar.png",
          fit: BoxFit.cover,
        ),
      ),
    );

    if (widget.enableNavigation) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/profil');
        },
        child: photoWidget,
      );
    }

    return photoWidget;
  }
}