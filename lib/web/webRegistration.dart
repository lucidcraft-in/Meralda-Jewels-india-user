import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meralda_gold_user/common/colo_extension.dart';
import 'package:meralda_gold_user/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firbase_storage;
import '../model/branchModel.dart';
import '../model/customerModel.dart';
import '../providers/account_provider.dart';
import '../providers/branchProvider.dart';
import 'webPayScreen.dart';

class UserRegistrationDialog extends StatefulWidget {
  final String? type;
  const UserRegistrationDialog({
    Key? key,
    required this.type,
  }) : super(key: key);
  @override
  State<UserRegistrationDialog> createState() => _UserRegistrationDialogState();
}

class _UserRegistrationDialogState extends State<UserRegistrationDialog> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  // Form controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _placeController = TextEditingController();
  final _nomineeController = TextEditingController();
  final _nomineePhoneController = TextEditingController();
  final _nomineeRelationController = TextEditingController();
  final _aadharController = TextEditingController();
  final _panController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _custIdController = TextEditingController();
  final openingAmtCntrl = TextEditingController();

  File? _aadharFrontImage;
  File? _aadharBackImage;
  File? _panCardImage;

  Uint8List? _aadharFrontImageBytes;
  Uint8List? _aadharBackImageBytes;
  Uint8List? _panCardImageBytes;

  // Dropdown values
  String? selectedSchemeType;
  final List<String> schemeTypeList = ["Wishlist", "Aspire"];
  String? selectedOdType;
  final List<String> orderAdvList = ["Gold", "Cash"];

  // Branch and country
  String? selectedBranch;
  String? selectedCountry;
  final List<String> branchList = ["Branch A", "Branch B", "Branch C"];
  final List<String> countryList = ["India", "UAE", "USA"];

  // Date fields
  DateTime? selectedDate;
  DateTime now = DateTime.now();
  bool _showAdditionalFields = false;
  var activeAccount;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  setData() {
    setState(() {
      final accountProvider = context.read<AccountProvider>();
      final accounts = accountProvider.accounts;
      if (accounts.isNotEmpty) {
        activeAccount = accounts[accountProvider.selectedAccountIndex];
        print(activeAccount);
        // Pre-fill only if not null
        _phoneController.text = activeAccount.phoneNo ?? "";
        _nameController.text = activeAccount.name ?? "";
        _addressController.text = activeAccount.address ?? "";
        _placeController.text = activeAccount.place ?? "";
        _emailController.text = activeAccount.mailId ?? "";
        selectedDate = activeAccount.dateofBirth;
        _nomineeController.text = activeAccount.nominee ?? "";
        _nomineePhoneController.text = activeAccount.nomineePhone ?? "";
        _nomineeRelationController.text = activeAccount.nomineeRelation ?? "";
        _aadharController.text = activeAccount.adharCard ?? "";
        _panController.text = activeAccount.panCard ?? "";
        _pinCodeController.text = activeAccount.pinCode ?? "";
        // selectedCountry = activeAccount.country;
        aadharFrontUrl = activeAccount.aadharFrontUrl;
        aadharBackUrl = activeAccount.aadharBackUrl;
        panCardUrl = activeAccount.panCardUrl;
        // only load if country is not null
        if (selectedCountry != null) {
          // wait until first frame is rendered before calling providers
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadBranches(selectedCountry!);
          });
        }
      }
    });
    print("---------");
    print(_nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 850),
        padding: EdgeInsets.all(isWeb ? 40 : 20),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),

                    // Main form fields in two columns for web
                    isWeb ? _buildWebForm(activeAccount!) : _buildMobileForm(),

                    const SizedBox(height: 30),
                    _buildRegisterButton(activeAccount!),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebForm(UserModel activeAccount) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              // Scheme Type
              _buildDropdown(
                label: "Scheme Type",
                value: selectedSchemeType,
                items: schemeTypeList,
                onChanged: (val) => setState(() {
                  selectedSchemeType = val;
                  _generateCustomerId(val == "Wishlist" ? "WL" : "ASP");
                }),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildCountryDropdown(),
                  ),
                  // Expanded(
                  //   child: _buildDropdown(
                  //     label: "Country",
                  //     value: selectedCountry,
                  //     items: countryList,
                  //     onChanged: (val) => setState(() => selectedCountry = val),
                  //   ),
                  // ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildBranchDropdown())
                  // Expanded(
                  //   child: _buildDropdown(
                  //     label: "Branch",
                  //     value: selectedBranch,
                  //     items: branchList,
                  //     onChanged: (val) => setState(() => selectedBranch = val),
                  //   ),
                  // ),
                ],
              ),
              if (activeAccount.name == "") const SizedBox(height: 16),

              // Customer Name
              if (activeAccount.name == "")
                _buildTextField("Customer Name", _nameController,
                    isRequired: true),
              if (activeAccount.custId == "") const SizedBox(height: 16),

              // Customer ID
              if (activeAccount.custId == "")
                _buildTextField("Customer ID", _custIdController,
                    isReadOnly: true),
              const SizedBox(height: 16),

              // Phone Number
              // if (_nameController.text == "")
              _buildTextField(
                "Phone Number",
                _phoneController,
                isRequired: true,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (value.length != 10) return 'Invalid phone number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField("Scheme Amount", openingAmtCntrl),
              if (activeAccount.address == "") const SizedBox(height: 16),
              // Address
              if (activeAccount.address == "")
                _buildTextField(
                  "Address",
                  _addressController,
                  isRequired: true,
                  maxLines: 3,
                ),

              // Country and Branch selection

              if (activeAccount.name == "") const SizedBox(height: 20),
              if (activeAccount.name == "") _buildKYCSection(activeAccount),
              const SizedBox(height: 20),
              // Additional fields checkbox
              // if (_nameController.text == "")
              if (activeAccount.name == "")
                Row(
                  children: [
                    Checkbox(
                      value: _showAdditionalFields,
                      onChanged: (value) => setState(
                          () => _showAdditionalFields = value ?? false),
                    ),
                    Text('Show Additional Fields'),
                  ],
                ),
              if (activeAccount.name == "") const SizedBox(height: 10),

              // Additional fields (conditionally shown)

              if (_showAdditionalFields) ...[
                if (activeAccount.name == "")
                  _buildTextField("Email", _emailController),
                if (activeAccount.name == "") const SizedBox(height: 16),
                if (activeAccount.name == "")
                  _buildTextField("Place", _placeController),
                if (activeAccount.name == "") const SizedBox(height: 16),
                if (activeAccount.name == "") _buildDateField("Date of Birth"),
                if (activeAccount.name == "") const SizedBox(height: 16),
                if (activeAccount.name == "")
                  _buildTextField("Nominee", _nomineeController),
                if (activeAccount.name == "") const SizedBox(height: 16),
                if (activeAccount.name == "")
                  _buildTextField("Nominee Phone", _nomineePhoneController,
                      keyboardType: TextInputType.phone),
                if (activeAccount.name == "") const SizedBox(height: 16),
                if (activeAccount.name == "")
                  _buildTextField(
                      "Nominee Relation", _nomineeRelationController),
                if (activeAccount.name == "") const SizedBox(height: 16),
                // _buildTextField("Aadhar Card", _aadharController),
                // const SizedBox(height: 16),
                // _buildTextField("PAN Card", _panController),
                // const SizedBox(height: 16),
                // _buildTextField("PIN Code", _pinCodeController,
                //     keyboardType: TextInputType.number),
                // const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKYCSection(UserModel user) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.name == "")
              Text('KYC Documents (Mandatory)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (user.adharCard == "") const SizedBox(height: 16),

            // Aadhar Number
            if (user.adharCard == "")
              _buildTextField(
                "Aadhar Number*",
                _aadharController,
                isRequired: true,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (value.length != 12) return 'Aadhar must be 12 digits';
                  if (!RegExp(r'^[0-9]+$').hasMatch(value))
                    return 'Only numbers allowed';
                  return null;
                },
              ),
            if (user.aadharFrontUrl == "") const SizedBox(height: 16),

            // Aadhar Card Front
            if (user.aadharFrontUrl == "")
              _buildImageUploadField(
                label: "Aadhar Front*",
                imageFile: _aadharFrontImage,
                imageBytes: _aadharFrontImageBytes,
                onPressed: () => _pickImage(true, true),
                isRequired: true,
              ),
            if (user.aadharBackUrl == "") const SizedBox(height: 16),

            // Aadhar Card Back
            if (user.aadharBackUrl == "")
              _buildImageUploadField(
                label: "Aadhar Back*",
                imageFile: _aadharBackImage,
                imageBytes: _aadharBackImageBytes,
                onPressed: () => _pickImage(true, false),
                isRequired: true,
              ),
            if (user.panCard == "") const SizedBox(height: 16),

            // PAN Number
            if (user.panCard == "")
              _buildTextField(
                "PAN Number*",
                _panController,
                isRequired: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (value.length != 10) return 'PAN must be 10 characters';
                  if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(value))
                    return 'Invalid PAN format (e.g., ABCDE1234F)';
                  return null;
                },
              ),
            if (user.panCardUrl == "") const SizedBox(height: 16),

            // PAN Card Image
            if (user.panCardUrl == "")
              _buildImageUploadField(
                label: "PAN Card*",
                imageFile: _panCardImage,
                imageBytes: _panCardImageBytes,
                onPressed: () => _pickImage(false, null),
                isRequired: true,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(bool isAadhar, bool? isFront) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // On Web, store bytes
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        if (isAadhar) {
          if (isFront!) {
            _aadharFrontImageBytes = bytes;
          } else {
            _aadharBackImageBytes = bytes;
          }
        } else {
          _panCardImageBytes = bytes;
        }
      });
    }
  }

  Widget _buildImageUploadField({
    required String label,
    File? imageFile,
    Uint8List? imageBytes,
    required VoidCallback onPressed,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onPressed,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(
                color: (imageFile == null && imageBytes == null && isRequired)
                    ? Colors.red
                    : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: (imageBytes != null)
                ? Image.memory(imageBytes, fit: BoxFit.cover)
                : (imageFile != null)
                    ? Image.file(imageFile, fit: BoxFit.cover)
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 40),
                            Text('Tap to upload $label'),
                          ],
                        ),
                      ),
          ),
        ),
        if (imageFile == null && imageBytes == null && isRequired)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text('This field is required',
                style: TextStyle(color: Colors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildMobileForm() {
    return Column(
      children: [
        // Scheme Type
        _buildDropdown(
          label: "Scheme Type",
          value: selectedSchemeType,
          items: schemeTypeList,
          onChanged: (val) => setState(() {
            selectedSchemeType = val;
            _generateCustomerId(val == "Wishlist" ? "WL" : "ASP");
          }),
        ),
        const SizedBox(height: 16),

        // Customer Name
        _buildTextField("Customer Name", _nameController, isRequired: true),
        const SizedBox(height: 16),

        // Customer ID
        _buildTextField("Customer ID", _custIdController, isReadOnly: true),
        const SizedBox(height: 16),

        // Order Advance Type
        _buildDropdown(
          label: "Order Advance",
          value: selectedOdType,
          items: orderAdvList,
          onChanged: (val) => setState(() => selectedOdType = val),
        ),
        const SizedBox(height: 16),

        // Phone Number
        _buildTextField(
          "Phone Number",
          _phoneController,
          isRequired: true,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required';
            if (value.length != 10) return 'Invalid phone number';
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Address
        _buildTextField(
          "Address",
          _addressController,
          isRequired: true,
          maxLines: 3,
        ),
        const SizedBox(height: 16),

        // Country and Branch selection
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                label: "Country",
                value: selectedCountry,
                items: countryList,
                onChanged: (val) => setState(() => selectedCountry = val),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdown(
                label: "Branch",
                value: selectedBranch,
                items: branchList,
                onChanged: (val) => setState(() => selectedBranch = val),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Additional fields checkbox
        Row(
          children: [
            Checkbox(
              value: _showAdditionalFields,
              onChanged: (value) =>
                  setState(() => _showAdditionalFields = value ?? false),
            ),
            Text('Show Additional Fields'),
          ],
        ),
        const SizedBox(height: 10),

        // Additional fields (conditionally shown)
        if (_showAdditionalFields) ...[
          _buildTextField("Email", _emailController),
          const SizedBox(height: 16),
          _buildTextField("Place", _placeController),
          const SizedBox(height: 16),
          _buildDateField("Date of Birth"),
          const SizedBox(height: 16),
          _buildTextField("Nominee", _nomineeController),
          const SizedBox(height: 16),
          _buildTextField("Nominee Phone", _nomineePhoneController,
              keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          _buildTextField("Nominee Relation", _nomineeRelationController),
          const SizedBox(height: 16),
          _buildTextField("Aadhar Card", _aadharController),
          const SizedBox(height: 16),
          _buildTextField("PAN Card", _panController),
          const SizedBox(height: 16),
          _buildTextField("PIN Code", _pinCodeController,
              keyboardType: TextInputType.number),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 180,
          height: 180,
          child: Image.asset("assets/images/merladlog_white.png"),
        ),
        SizedBox(height: 10),
        Text(
          "Customer Registration",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: TColo.primaryColor1,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    bool isReadOnly = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label + (isRequired ? ' *' : ''),
        filled: true,
        fillColor: Colors.grey[50],
        prefixIcon: Icon(Icons.edit_outlined, color: TColo.primaryColor1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: TColo.primaryColor1, width: 2),
        ),
      ),
      validator: validator ??
          (isRequired
              ? (value) => value?.isEmpty ?? true ? 'Required' : null
              : null),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: TColo.primaryColor1, width: 2),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select $label' : null,
    );
  }

  Widget _buildDateField(String label) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.grey[50],
            prefixIcon: Icon(Icons.calendar_today, color: TColo.primaryColor1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: TColo.primaryColor1, width: 2),
            ),
          ),
          controller: TextEditingController(
            text: selectedDate == null
                ? DateFormat('MMM dd, yyyy').format(now)
                : DateFormat('MMM dd, yyyy').format(selectedDate!),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  _buildRegisterButton(UserModel activeAc) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          if (_isLoading) {
          } else {
            _submitForm(activeAc);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: TColo.primaryColor1,
          foregroundColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                "Register",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  String? aadharFrontUrl;
  String? aadharBackUrl;
  String? panCardUrl;

  bool isClick = false;
  bool _isLoading = false;
  Future<void> _submitForm(UserModel user) async {
    if (isClick) return;

    // Validate form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields correctly!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate dropdown selections
    if (selectedSchemeType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select both Scheme Type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate country and branch selection
    if (selectedCountry == null || selectedBranch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select both Country and Branch'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_nameController.text == "") {
      if (_aadharFrontImageBytes == null ||
          _aadharBackImageBytes == null ||
          _panCardImageBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please upload all required documents!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
    if (double.parse(openingAmtCntrl.text) < 2000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening amount cannot be less than 2000!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Save form data
    _formKey.currentState!.save();

    setState(() {
      isClick = true;
      _isLoading = true;
    });

    // try {
    //   // Upload images
    //   String? aadharFrontUrl = await _uploadImage(
    //     file: _aadharFrontImage,
    //     bytes: _aadharFrontImageBytes,
    //     path: '${_custIdController.text}_aadhar_front.jpg',
    //   );

    //   String? aadharBackUrl = await _uploadImage(
    //     file: _aadharBackImage,
    //     bytes: _aadharBackImageBytes,
    //     path: '${_custIdController.text}_aadhar_back.jpg',
    //   );

    //   String? panCardUrl = await _uploadImage(
    //     file: _panCardImage,
    //     bytes: _panCardImageBytes,
    //     path: '${_custIdController.text}_pan_card.jpg',
    //   );
    //   if (aadharFrontUrl == null ||
    //       aadharBackUrl == null ||
    //       panCardUrl == null) {
    //     throw 'Failed to upload one or more images';
    //   }
    //   // Create user model from form data
    //   final user = UserModel(
    //     createdDate: DateTime.now(),
    //     id: '', // Will be generated by Firestore
    //     name: _nameController.text,
    //     custId: _custIdController.text,
    //     phoneNo: _phoneController.text,
    //     address: _addressController.text,
    //     place: _placeController.text,
    //     mailId: _emailController.text,
    //     staffId: '', // Will be set based on logged-in staff
    //     schemeType: selectedSchemeType!,
    //     balance: 0,
    //     openingAmount: double.parse(openingAmtCntrl.text),
    //     token: '',
    //     totalGram: 0,
    //     branch: selectedBranchObject?.id ?? '',
    //     branchName: selectedBranch ?? '',
    //     dateofBirth: selectedDate ?? DateTime.now(),
    //     nominee: _nomineeController.text,
    //     nomineePhone: _nomineePhoneController.text,
    //     nomineeRelation: _nomineeRelationController.text,
    //     adharCard: _aadharController.text,
    //     panCard: _panController.text,
    //     pinCode: _pinCodeController.text,
    //     staffName: '', // Will be set based on logged-in staff
    //     tax: 0,
    //     amc: 0,
    //     country: selectedCountry ?? '',
    //     aadharFrontUrl: aadharFrontUrl,
    //     aadharBackUrl: aadharBackUrl,
    //     panCardUrl: panCardUrl,
    //   );

    //   bool? isCreated = await Provider.of<User>(context, listen: false).create(
    //       user,
    //       _custIdController.text,
    //       selectedSchemeType!,
    //       '',
    //       '',
    //       selectedOdType!);

    //   if (!isCreated!) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Customer created successfully!'),
    //         backgroundColor: Colors.green,
    //       ),
    //     );
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('you can login after verification complete'),
    //         backgroundColor: Colors.green,
    //       ),
    //     );

    //     // Close the dialog on success
    //     Navigator.of(context).pop();
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Customer ID already exists!'),
    //         backgroundColor: Colors.red,
    //       ),
    //     );
    //   }
    // } catch (err) {
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (ctx) => AlertDialog(
    //       title: Text('Error'),
    //       content: Text('Failed to create customer: $err'),
    //       actions: [
    //         TextButton(
    //           child: Text('OK'),
    //           onPressed: () => Navigator.of(ctx).pop(),
    //         )
    //       ],
    //     ),
    //   );
    // } finally {
    //   if (mounted) {
    //     setState(() {
    //       isClick = false;
    //       _isLoading = false;
    //     });
    //   }
    // }

    // Upload images first
    if (user.aadharFrontUrl == "") {
      aadharFrontUrl = await _uploadImage(
        file: _aadharFrontImage,
        bytes: _aadharFrontImageBytes,
        path: '${_custIdController.text}_aadhar_front.jpg',
      );
    }
    if (user.aadharBackUrl == "") {
      aadharBackUrl = await _uploadImage(
        file: _aadharBackImage,
        bytes: _aadharBackImageBytes,
        path: '${_custIdController.text}_aadhar_back.jpg',
      );
    }
    if (user.panCard == "") {
      panCardUrl = await _uploadImage(
        file: _panCardImage,
        bytes: _panCardImageBytes,
        path: '${_custIdController.text}_pan_card.jpg',
      );
    }
    if (user.name == "") {
      if (aadharFrontUrl == null ||
          aadharBackUrl == null ||
          panCardUrl == null) {
        throw 'Failed to upload one or more images';
      }
    }

    if (widget.type != "add") {
      print("------- update --------");
      try {
        final activeAccount = context.read<AccountProvider>().currentAccount;

        if (activeAccount != null && activeAccount.id != null) {
          // ✅ Update existing Firestore doc
          await FirebaseFirestore.instance
              .collection('user')
              .doc(activeAccount.id)
              .update({
            "name": _nameController.text,
            "custId": _custIdController.text,
            "address": _addressController.text,
            "place": _placeController.text,
            "mailId": _emailController.text,
            "schemeType": selectedSchemeType!,
            "openingAmount": double.parse(openingAmtCntrl.text),
            "branch": selectedBranchObject?.id ?? '',
            "branchName": selectedBranch ?? '',
            "dateofBirth": selectedDate ?? DateTime.now(),
            "nominee": _nomineeController.text,
            "nomineePhone": _nomineePhoneController.text,
            "nomineeRelation": _nomineeRelationController.text,
            "adharCard": _aadharController.text,
            "panCard": _panController.text,
            "pinCode": _pinCodeController.text,
            "country": selectedCountry ?? '',
            "aadharFrontUrl": aadharFrontUrl,
            "aadharBackUrl": aadharBackUrl,
            "panCardUrl": panCardUrl,
            "updatedDate": DateTime.now(),
            "status": CustomerStatus.created
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account updated successfully!')),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => WebPayAmountScreen(
                  // user: activeAccount.toMap(),
                  // userid: activeAccount.id,
                  // custName: activeAccount.name,
                  ),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          // fallback if no activeAccount
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No active account found to update!')),
          );
        }
      } catch (err) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to update account: $err'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(ctx).pop(),
              )
            ],
          ),
        );
      }
    } else {
      print("------- add --------");
      try {
        final user = UserModel(
            createdDate: DateTime.now(),
            name: _nameController.text,
            custId: _custIdController.text,
            phoneNo: _phoneController.text,
            address: _addressController.text,
            place: _placeController.text,
            mailId: _emailController.text,
            staffId: '', // Will be set based on logged-in staff
            schemeType: selectedSchemeType!,
            balance: 0,
            openingAmount: double.parse(openingAmtCntrl.text),
            token: '',
            totalGram: 0,
            branch: selectedBranchObject?.id ?? '',
            branchName: selectedBranch ?? '',
            dateofBirth: selectedDate ?? DateTime.now(),
            nominee: _nomineeController.text,
            nomineePhone: _nomineePhoneController.text,
            nomineeRelation: _nomineeRelationController.text,
            adharCard: _aadharController.text,
            panCard: _panController.text,
            pinCode: _pinCodeController.text,
            staffName: '', // Will be set based on logged-in staff
            tax: 0,
            amc: 0,
            country: selectedCountry ?? '',
            aadharFrontUrl: aadharFrontUrl,
            aadharBackUrl: aadharBackUrl,
            panCardUrl: panCardUrl,
            updatedDate: DateTime.now(),
            status: CustomerStatus.created);
        print(user.toMap().toString());
        // bool? isCreated = await Provider.of<User>(context, listen: false)
        //     .create(user, _custIdController.text, selectedSchemeType!, '', '',
        //         selectedOdType!);
        // ✅ Add document (auto-generated ID by Firestore)
        final docRef = await FirebaseFirestore.instance.collection('user').add({
          ...user.toMap(),
          "createdDate": FieldValue.serverTimestamp(),
          "updatedDate": FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Customer created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => WebPayAmountScreen(
              user: user.toMap(),
              userid: docRef.id, // Firestore document id
              custName: user.name,
            ),
          ),
          (Route<dynamic> route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You can login after verification is complete'),
            backgroundColor: Colors.green,
          ),
        );

        // if (!isCreated!) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Customer created successfully!'),
        //     backgroundColor: Colors.green,
        //   ),
        // );
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('you can login after verification complete'),
        //     backgroundColor: Colors.green,
        //   ),
        // );

        // // Close the dialog on success
        // Navigator.of(context).pop();
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Customer ID already exists!'),
        //       backgroundColor: Colors.red,
        //     ),
        //   );
        // }
      } catch (err) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to create customer: $err'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(ctx).pop(),
              )
            ],
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            isClick = false;
            _isLoading = false;
          });
        }
      }
    }
  }

  Widget _buildCountryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCountry,
      decoration: InputDecoration(
        labelText: "Country",
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: TColo.primaryColor1, width: 2),
        ),
      ),
      items: countryList.map((country) {
        return DropdownMenuItem<String>(
          value: country,
          child: Text(country),
        );
      }).toList(),
      onChanged: (value) async {
        if (value != null) {
          await _loadBranches(value);
        }
        setState(() {
          selectedCountry = value;
        });
      },
      validator: (value) => value == null ? 'Please select Country' : null,
    );
  }

  Future<void> _generateCustomerId(String schemePrefix) async {
    // In a real app, you would generate this from your backend
    final mockCounter = DateTime.now().millisecondsSinceEpoch % 1000;
    setState(() {
      _custIdController.text = '${schemePrefix}_$mockCounter';
    });
  }

  List<Branch> filteredBranches = [];
  Branch? selectedBranchObject;
  Future<void> _loadBranches(String country) async {
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    await branchProvider.fetchBranches(country);
    setState(() {
      filteredBranches = branchProvider.branches;
      // Reset selected branch when country changes
      selectedBranch = null;
      selectedBranchObject = null;
    });
  }

  Widget _buildBranchDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedBranch,
      decoration: InputDecoration(
        labelText: "Branch",
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: TColo.primaryColor1, width: 2),
        ),
      ),
      items: filteredBranches.map((branch) {
        return DropdownMenuItem<String>(
          value: branch.branchName,
          child: Text(branch.branchName),
          onTap: () {
            selectedBranchObject = branch;
          },
        );
      }).toList(),
      onChanged: (value) => setState(() {
        selectedBranch = value;
      }),
      validator: (value) {
        if (selectedCountry == null) return 'Please select country first';
        if (value == null) return 'Please select Branch';
        return null;
      },
      disabledHint: Text(selectedCountry == null
          ? 'Select country first'
          : filteredBranches.isEmpty
              ? 'No branches available'
              : 'Select branch'),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _placeController.dispose();
    _nomineeController.dispose();
    _nomineePhoneController.dispose();
    _nomineeRelationController.dispose();
    _aadharController.dispose();
    _panController.dispose();
    _pinCodeController.dispose();
    _custIdController.dispose();
    super.dispose();
  }

  Future<String?> _uploadImage({
    File? file,
    Uint8List? bytes,
    required String path,
  }) async {
    try {
      print("==================");
      print(path);
      final FirebaseStorage storage = FirebaseStorage.instance;

      // IMPORTANT: Use 'public/' prefix to match your storage rules
      final String publicPath = 'public/$path';

      TaskSnapshot taskSnapshot;

      // Check if we're on web platform or have bytes data

      // For web platform or when bytes are provided
      if (bytes != null) {
        taskSnapshot = await storage.ref(publicPath).putData(bytes);
      } else if (file != null) {
        // Read file as bytes for web
        final fileBytes = await file.readAsBytes();
        taskSnapshot = await storage.ref(publicPath).putData(fileBytes);
      } else {
        throw Exception('No file or bytes provided');
      }

      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print('Upload successful to public storage: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image $path: $e');
      return null;
    }
  }
}
