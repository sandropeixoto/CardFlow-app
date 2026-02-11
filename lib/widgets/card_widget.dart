import 'dart:ui';

import 'package:card_flow/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardWidget extends StatefulWidget {
  final CreditCard card;

  const CardWidget({super.key, required this.card});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool _isSensitiveDataVisible = false;

  void _toggleSensitiveDataVisibility() {
    setState(() {
      _isSensitiveDataVisible = !_isSensitiveDataVisible;
    });
  }

  LinearGradient _getCardGradient(String brand) {
    brand = brand.toLowerCase();
    if (brand.contains('nubank')) {
      return const LinearGradient(
        colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA), Color(0xFFB549C6)],
        begin: Alignment.topLeft, end: Alignment.bottomRight);
    } else if (brand.contains('itau') || brand.contains('itaú')) {
      return const LinearGradient(
        colors: [Color(0xFFE65100), Color(0xFFEF6C00), Color(0xFFF57C00)],
        begin: Alignment.topLeft, end: Alignment.bottomRight);
    } else if (brand.contains('visa')) {
      return const LinearGradient(
        colors: [Color(0xFF1A237E), Color(0xFF283593), Color(0xFF3F51B5)],
        begin: Alignment.topLeft, end: Alignment.bottomRight);
    } else if (brand.contains('mastercard')) {
        return const LinearGradient(
        colors: [Color(0xFFD32F2F), Color(0xFFE53935), Color(0xFFF44336)],
        begin: Alignment.topLeft, end: Alignment.bottomRight);
    } else {
      return const LinearGradient(
        colors: [Color(0xFF424242), Color(0xFF616161), Color(0xFF757575)],
        begin: Alignment.topLeft, end: Alignment.bottomRight);
    }
  }

  Widget _getBrandLogo(String brand) {
    return Text(
      brand.toUpperCase(),
      style: GoogleFonts.poppins(
        color: Colors.white.withOpacity(0.8),
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: _getCardGradient(widget.card.brand),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getCardGradient(widget.card.brand).colors.first.withOpacity(0.4),
            blurRadius: 25,
            spreadRadius: -10,
            offset: const Offset(0, 15),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Card Alias and Brand
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.card.alias,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _getBrandLogo(widget.card.brand),
              ],
            ),

            // Sensitive Data Section with Glassmorphism
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _isSensitiveDataVisible ? 5.0 : 0.0,
                  sigmaY: _isSensitiveDataVisible ? 5.0 : 0.0,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(_isSensitiveDataVisible ? 0.15 : 0.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '**** **** **** ${widget.card.lastFourDigits}',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(_isSensitiveDataVisible ? 1.0 : 0.7),
                          fontSize: 24,
                          letterSpacing: 3.0,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'CVV: ${_isSensitiveDataVisible ? widget.card.cvv : '***'}',
                            style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(_isSensitiveDataVisible ? 1.0 : 0.7),
                                fontSize: 16,
                                letterSpacing: 1.5),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: _toggleSensitiveDataVisibility,
                            child: Icon(
                              _isSensitiveDataVisible
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Due Day and AutoPay Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Venc.: Dia ${widget.card.dueDay}',
                  style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9), fontSize: 16),
                ),
                Row(
                  children: [
                    Text(
                      'Déb. Auto: ',
                       style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.9), fontSize: 16),
                    ),
                    Icon(
                      widget.card.isAutoPay ? Icons.check_circle : Icons.cancel,
                      color: widget.card.isAutoPay ? Colors.greenAccent.shade400 : Colors.redAccent.shade400,
                      size: 22,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
