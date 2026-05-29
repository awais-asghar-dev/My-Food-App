import 'package:flutter/material.dart';

class LogoHome extends StatelessWidget {
  final double size;
  final Color? color;

  const LogoHome({
    super.key,
    this.size = 50,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = color ?? Colors.orange;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(size * 0.3),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Plate background
              Positioned(
                top: size * 0.1,
                left: size * 0.1,
                right: size * 0.1,
                bottom: size * 0.1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),

              // Pizza slice
              Positioned(
                top: size * 0.2,
                left: size * 0.25,
                child: Transform.rotate(
                  angle: 0.5,
                  child: Container(
                    width: size * 0.4,
                    height: size * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.orange[800],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size * 0.2),
                        bottomRight: Radius.circular(size * 0.2),
                        bottomLeft: Radius.circular(size * 0.1),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Pepperoni 1
                        Positioned(
                          top: size * 0.12,
                          left: size * 0.12,
                          child: Container(
                            width: size * 0.08,
                            height: size * 0.08,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        // Pepperoni 2
                        Positioned(
                          top: size * 0.25,
                          left: size * 0.25,
                          child: Container(
                            width: size * 0.06,
                            height: size * 0.06,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Utensils
              Positioned(
                bottom: size * 0.3,
                left: size * 0.15,
                child: Icon(
                  Icons.restaurant,
                  color: primaryColor,
                  size: size * 0.2,
                ),
              ),

              // Delivery icon
              Positioned(
                bottom: size * 0.3,
                right: size * 0.15,
                child: Icon(
                  Icons.delivery_dining,
                  color: primaryColor,
                  size: size * 0.2,
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
