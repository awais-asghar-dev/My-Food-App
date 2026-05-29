import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final double height;
  final bool autoPlay;
  final Duration autoPlayInterval;

  const CustomCarousel({
    super.key,
    required this.imageUrls,
    this.height = 150,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
  });

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay && widget.imageUrls.length > 1) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (_pageController.hasClients) {
        if (_currentPage < widget.imageUrls.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTapDown: (_) => _stopAutoPlay(),
                onTapCancel: () => _startAutoPlay(),
                onTapUp: (_) => _startAutoPlay(),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: widget.imageUrls[index].isEmpty
                              ? Container(
                                  color: Colors.orange.shade50,
                                  child: const Center(
                                    child: Icon(Icons.fastfood, color: Colors.orange, size: 50),
                                  ),
                                )
                              : Image.network(
                                  widget.imageUrls[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.orange.shade50,
                                      child: const Center(
                                        child: Icon(Icons.fastfood, color: Colors.orange, size: 50),
                                      ),
                                    );
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey[100],
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.black.withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Get 30% OFF\nOn Your First Order!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        if (widget.imageUrls.length > 1)
          SmoothPageIndicator(
            controller: _pageController,
            count: widget.imageUrls.length,
            effect: const ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: Colors.orange,
            ),
          ),
      ],
    );
  }
}