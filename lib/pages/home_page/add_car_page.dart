import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:car_tracker/models/fuel_type.dart';
import 'package:car_tracker/services/car_manager.dart';
import 'package:car_tracker/services/image_picker.dart';
import 'package:car_tracker/widgets/app_dropdown_field.dart';
import 'package:car_tracker/widgets/app_label.dart';
import 'package:car_tracker/widgets/app_section_heading.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/models/car.dart';
import 'package:car_tracker/utils.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'dart:io';
import 'package:car_tracker/widgets/app_text_field.dart';

class AddCarPage extends StatefulWidget{
  final Car? car;
  const AddCarPage({super.key, this.car});

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final _nameController = TextEditingController();
  final _mileageController = TextEditingController();
  FuelTypeCar? _fuelType;
  final ImagePickerService _imagePickerService = ImagePickerService();
  File? _selectedImage;
  
  @override
  void initState() {
    super.initState();
    final car = widget.car;
    if (car != null) {
      _nameController.text = car.name;
      _mileageController.text = car.mileage.toString();
      _fuelType = car.fuelType;
      if (car.imgPath != null) {
        _selectedImage = File(car.imgPath!);
      }
    } 
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить автомобиль'),
        titleTextStyle: const TextStyle(
          color: AppTheme.textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildContent(l10n),
        ),
      );
  }

  Widget _buildContent(AppLocalizations l10n) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          AppSectionHeading(title: "Фото", subtitle: "Фоточка авто",),
          GestureDetector(
            onTap:_pickImage,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 200,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: _selectedImage == null ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 48, color: AppTheme.primaryColor,),
                    SizedBox(height: 8,),
                    Text("Добавить фотографию")
                  ],
                ) : Image.file(_selectedImage!, fit: BoxFit.cover)  
              ),
            ),
          ),
          const SizedBox(height: 16,),
          AppSectionHeading(title: "Основная информация"),
          AppLabel(text: "Название автомобиля"),
          AppTextField(controller: _nameController),
          AppLabel(text: "Тип топлива"),
          AppDropdownField<FuelTypeCar>(
            hint: "Тип топлива",
            value: _fuelType,
            items: FuelTypeCar.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(fuelTypeCarName(type)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _fuelType = value;
              });
            },
          ),
          AppLabel(text: "Текущий пробег"),
          AppTextField(
            controller: _mileageController,
            keyboardType: TextInputType.number,
            suffix: 'км',
            
          ),
          SizedBox(height: 16,),
            SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: AppTheme.backgroundColor,
              ),
              child: const Text('Сохранить'),
            ),
          ),
          ],
      )
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final mileage = int.tryParse(_mileageController.text);
    if (name.isEmpty || mileage == null || _fuelType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Заполните все поля"))
      );
      return;
    }

    final car = Car(id: widget.car?.id, name: name, imgPath: _selectedImage?.path, fuelType: _fuelType!, mileage: mileage);
    if (widget.car == null) {
      await CarManager.instance.add(car);
    } else {
      await CarManager.instance.update(car);
    }
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final image = await _imagePickerService.pickImage(context);
    if (image == null) {
      return;
    }
    setState(() {
      _selectedImage = image as File?;
    });
  }
}