import 'package:flutter/material.dart';

class InfoStepModel {
   late String title;
   late String description;
   late String buttonText;
   final IconData? icon; // New field

   InfoStepModel({
    required this.title,
    required this.description,
    required this.buttonText, this.icon,

   });
}