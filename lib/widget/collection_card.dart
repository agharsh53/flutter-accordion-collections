import 'package:flutter/material.dart';
import '../models/collection_model.dart';

class CollectionCard extends StatefulWidget {
  final Collection collection;
  final VoidCallback onTap;
  final bool isExpanded;

  const CollectionCard({
    super.key,
    required this.collection,
    required this.onTap,
    required this.isExpanded,
  });

  @override
  State<CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends State<CollectionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heightAnimation = Tween<double>(
      begin: 0,
      end: 140, // Height for horizontal images row when expanded
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isExpanded) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CollectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header Section - Always Visible
          InkWell(
            onTap: widget.onTap,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: widget.isExpanded? BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16))
                    :const BorderRadius.all(Radius.circular(16)),
                color: const Color(0xFFFCE4EC),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.collection.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AnimatedRotation(
                    turns: widget.isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.expand_more,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content with Animation - Horizontal Images
          AnimatedBuilder(
            animation: _heightAnimation,
            builder: (context, child) {
              return Container(
                height: _heightAnimation.value,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  color: const Color(0xFFFCE4EC),
                ),
                child: child,
              );
            },
            child: _buildExpandedContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    // Return empty container if not expanded
    if (!widget.isExpanded) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // Always show 3 items max (the 3rd one might be overlay)
        itemCount: widget.collection.productImageUrls.length > 3 ? 3 : widget.collection.productImageUrls.length,
        itemBuilder: (context, index) {
          // Check if we need to show overlay on 3rd image
          final hasMoreImages = widget.collection.productImageUrls.length > 3;
          final isThirdImage = index == 2;
          final remainingImages = widget.collection.productImageUrls.length - 3;

          // For the 3rd position, show overlay if there are more images
          if (isThirdImage && hasMoreImages) {
            return _buildOverlayImage(remainingImages);
          }

          // For normal images (1st, 2nd, or 3rd if no overlay needed)
          final urlIndex = index;
          if (urlIndex < widget.collection.productImageUrls.length) {
            final url = widget.collection.productImageUrls[urlIndex];
            return _buildProductImage(url, false, 0);
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildProductImage(String url, bool isOverlay, int remainingCount) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFFCE4EC),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),

          // Overlay if this is the overlay image
          if (isOverlay)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withOpacity(0.6),
              ),
              child: Center(
                child: Text(
                  '+$remainingCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOverlayImage(int remainingCount) {
    // Show the actual 3rd image with overlay
    final url = widget.collection.productImageUrls[2];
    return _buildProductImage(url, true, remainingCount);
  }
}