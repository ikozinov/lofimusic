import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerLoader extends StatelessWidget {
  final String title;
  final String description;
  final bool isLoading;
  final String? errorMsg;
  final double size;

  const PlayerLoader({
    super.key,
    required this.title,
    required this.description,
    required this.isLoading,
    this.errorMsg,
    this.size = 78,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading && errorMsg == null) {
      return const SizedBox.shrink();
    }

    String displayTitle = errorMsg != null ? "$title failed" : title;
    String displayDesc = errorMsg ?? description;
    Color descColor = errorMsg != null ? const Color(0xFFF06372) : const Color(0xFFC0C0C0); // silver

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular progress loader (matching .loader .icon.active)
            SizedBox(
              width: size,
              height: size,
              child: errorMsg != null
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFC0C0C0), width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '!',
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFFC0C0C0),
                            fontSize: 36,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                  : CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                      backgroundColor: const Color(0xFFC0C0C0), // silver
                    ),
            ),
            const SizedBox(width: 24), // hspace-in padding equivalent
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayTitle.toUpperCase(),
                  style: GoogleFonts.montserrat(
                    fontSize: 26, // .h2 size
                    fontWeight: FontWeight.w400,
                    letterSpacing: 4,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayDesc,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: descColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
