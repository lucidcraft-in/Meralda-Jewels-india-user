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
import 'helperWidget.dart/documentsDialog.dart';
import 'helperWidget.dart/errorDialog.dart';
import 'webPayScreen.dart';

class UserRegistrationDialog extends StatefulWidget {
  final String? type;
  var user;
  UserRegistrationDialog({
    Key? key,
    required this.user,
    required this.type,
  }) : super(key: key);
  @override
  State<UserRegistrationDialog> createState() => _UserRegistrationDialogState();
}

class _UserRegistrationDialogState extends State<UserRegistrationDialog> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
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
  final List<String> schemeTypeList = [
    "Wishlist - Bonus Scheme",
    "Aspire - Metal Scheme"
  ];
  String? selectedOdType;
  final List<String> orderAdvList = ["Gold", "Cash"];

  // Branch and country
  String? selectedBranch;
  String? selectedCountry;
  final List<String> branchList = ["Branch A", "Branch B", "Branch C"];
  final List<String> countryList = [
    "India",
  ];

  bool _acceptTnc = false;

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
      } else {
        _phoneController.text = widget.user["phoneNo"] ?? "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
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
                      isWeb ? _buildWebForm() : _buildMobileForm(),

                      const SizedBox(height: 30),
                      _buildRegisterButton(),
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
      ),
    );
  }

  // Widget _buildWebForm() {
  //   print("=====================");
  //   print(activeAccount);
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Expanded(
  //         child: Column(
  //           children: [
  //             // Scheme Type
  //             _buildDropdown(
  //               label: "Scheme Type",
  //               value: selectedSchemeType,
  //               items: schemeTypeList,
  //               onChanged: (val) => setState(() {
  //                 selectedSchemeType = val;
  //                 _generateCustomerId(val == "Wishlist" ? "WL" : "ASP");
  //               }),
  //             ),
  //             const SizedBox(height: 16),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: _buildCountryDropdown(),
  //                 ),
  //                 // Expanded(
  //                 //   child: _buildDropdown(
  //                 //     label: "Country",
  //                 //     value: selectedCountry,
  //                 //     items: countryList,
  //                 //     onChanged: (val) => setState(() => selectedCountry = val),
  //                 //   ),
  //                 // ),
  //                 const SizedBox(width: 16),
  //                 Expanded(child: _buildBranchDropdown())
  //               ],
  //             ),
  //             if (activeAccount == null) const SizedBox(height: 16),

  //             // // Customer Name
  //             if (activeAccount == null)
  //               _buildTextField(
  //                   "Customer Name", Icons.person_outline, _nameController,
  //                   isRequired: true),
  //             if (activeAccount == null) const SizedBox(height: 16),

  //             // // Customer ID
  //             if (activeAccount == null)
  //               _buildTextField(
  //                   "Customer ID", Icons.badge_outlined, _custIdController,
  //                   isReadOnly: true),
  //             const SizedBox(height: 16),

  //             // // Phone Number
  //             if (activeAccount == null)
  //               _buildTextField(
  //                 "Phone Number",
  //                 Icons.phone_outlined,
  //                 _phoneController,
  //                 isRequired: true,
  //                 keyboardType: TextInputType.phone,
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) return 'Required';
  //                   if (value.length != 10) return 'Invalid phone number';
  //                   return null;
  //                 },
  //               ),
  //             const SizedBox(height: 16),
  //             _buildTextField(
  //                 "Scheme Amount", Icons.attach_money, openingAmtCntrl),
  //             if (activeAccount == null) const SizedBox(height: 16),
  //             // Address
  //             if (activeAccount == null)
  //               _buildTextField(
  //                 "Address",
  //                 Icons.home_outlined,
  //                 _addressController,
  //                 isRequired: true,
  //                 maxLines: 3,
  //               ),

  //             // // Country and Branch selection

  //             if (activeAccount == null) const SizedBox(height: 20),
  //             if (activeAccount == null) _buildKYCSection(),
  //             const SizedBox(height: 20),
  //             // // Additional fields checkbox
  //             // // if (_nameController.text == "")
  //             if (activeAccount == null)
  //               Row(
  //                 children: [
  //                   Checkbox(
  //                     value: _showAdditionalFields,
  //                     onChanged: (value) => setState(
  //                         () => _showAdditionalFields = value ?? false),
  //                   ),
  //                   Text('Show Additional Fields'),
  //                 ],
  //               ),
  //             if (activeAccount == null) const SizedBox(height: 10),

  //             // Additional fields (conditionally shown)

  //             if (_showAdditionalFields) ...[
  //               if (activeAccount == null)
  //                 _buildTextField(
  //                     "Email", Icons.email_outlined, _emailController),
  //               if (activeAccount == null) const SizedBox(height: 16),
  //               if (activeAccount == null)
  //                 _buildTextField(
  //                     "Place", Icons.location_on_outlined, _placeController),
  //               if (activeAccount == null) const SizedBox(height: 16),
  //               if (activeAccount == null) _buildDateField("Date of Birth"),
  //               if (activeAccount == null) const SizedBox(height: 16),
  //               if (activeAccount == null)
  //                 _buildTextField(
  //                     "Nominee", Icons.person_outline, _nomineeController),
  //               if (activeAccount == null) const SizedBox(height: 16),
  //               if (activeAccount == null)
  //                 _buildTextField("Nominee Phone", Icons.phone_outlined,
  //                     _nomineePhoneController,
  //                     keyboardType: TextInputType.phone),
  //               if (activeAccount == null) const SizedBox(height: 16),
  //               if (activeAccount == null)
  //                 _buildTextField("Nominee Relation", Icons.group_outlined,
  //                     _nomineeRelationController),
  //               if (activeAccount == null) const SizedBox(height: 16),
  //             ],
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  String? selectedSchemeDisplay;
  Widget _buildWebForm() {
    // Determine if we're in "new account" mode (activeAccount is null)
    final bool isNewAccount = activeAccount == null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              // Scheme Type (always shown)
              // _buildDropdown(
              //   label: "Scheme Type",
              //   value: selectedSchemeType,
              //   items: schemeTypeList,
              //   onChanged: (val) => setState(() {
              //     selectedSchemeType = val;
              //     _generateCustomerId(val == "Wishlist" ? "WL" : "ASP");
              //   }),
              // ),
              _buildDropdown(
                label: "Scheme Type",
                value: selectedSchemeDisplay,
                items: schemeTypeList,
                onChanged: (val) {
                  setState(() {
                    selectedSchemeDisplay = val;

                    if (val == "Wishlist - Bonus Scheme") {
                      selectedSchemeType = "Wishlist";
                      // _generateCustomerId("WL");
                    } else if (val == "Aspire - Metal Scheme") {
                      selectedSchemeType = "Aspire";
                      // _generateCustomerId("ASP");
                    }
                  });
                },
              ),
              const SizedBox(height: 16),

              // Country and Branch (always shown)
              Row(
                children: [
                  Expanded(
                    child: _buildCountryDropdown(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildBranchDropdown())
                ],
              ),
              const SizedBox(height: 16),

              // Customer Name (only for new accounts)
              if (isNewAccount) ...[
                _buildTextField(
                    "Customer Name", Icons.person_outline, _nameController,
                    isRequired: true),
                const SizedBox(height: 16),
              ],

              // Customer ID (only for new accounts)
              // if (isNewAccount) ...[
              //   _buildTextField(
              //       "Customer ID", Icons.badge_outlined, _custIdController,
              //       isReadOnly: true),
              //   const SizedBox(height: 16),
              // ],

              // Phone Number (only for new accounts)
              if (isNewAccount) ...[
                _buildTextField(
                  "Phone Number",
                  Icons.phone_outlined,
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
              ],

              if (selectedSchemeType == "Aspire") ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ...[2000, 3000, 4000, 5000].map((amount) {
                        return ChoiceChip(
                          label: Text("₹$amount"),
                          selected: openingAmtCntrl.text == amount.toString(),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                openingAmtCntrl.text = amount.toString();
                              });
                            }
                          },
                        );
                      }).toList(),
                      // 👇 Custom amount input
                      SizedBox(
                        width: 120,
                        child: TextField(
                          controller: openingAmtCntrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Custom",
                            prefixText: "₹ ",
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              // clear chip selection when custom amount typed
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Scheme Amount (always shown)
              _buildTextField(
                "Scheme Amount",
                Icons.attach_money,
                openingAmtCntrl,
                isRequired: true,
                isReadOnly: selectedSchemeType == "Aspire",
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline,
                          size: 14, color: Colors.orange.shade600),
                      SizedBox(width: 4),
                      Text(
                        "Minimum ₹2000",
                        style: TextStyle(
                            color: Colors.orange.shade700, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Address (only for new accounts)
              if (isNewAccount) ...[
                _buildTextField(
                  "Address",
                  Icons.home_outlined,
                  _addressController,
                  isRequired: true,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
              ],
              if (isNewAccount) ...[
                _buildTextField(
                  "Pin Code",
                  Icons.pin_drop,
                  _pinCodeController,
                  isRequired: true,
                  maxLines: 1,
                ),
                const SizedBox(height: 16),
              ],

              // KYC Section (only for new accounts)
              if (isNewAccount) ...[
                _buildKYCSection(),
                const SizedBox(height: 20),
              ],

              // Additional fields checkbox (only for new accounts)
              if (isNewAccount) ...[
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
                const SizedBox(height: 10),
              ],

              // Additional fields (conditionally shown, only for new accounts)
              if (isNewAccount && _showAdditionalFields) ...[
                _buildTextField(
                    "Email", Icons.email_outlined, _emailController),
                const SizedBox(height: 16),
                _buildTextField(
                    "Place", Icons.location_on_outlined, _placeController),
                const SizedBox(height: 16),
                _buildDateField("Date of Birth"),
                const SizedBox(height: 16),
                _buildTextField(
                    "Nominee", Icons.person_outlined, _nomineeController),
                const SizedBox(height: 16),
                _buildTextField("Nominee Phone", Icons.phone_outlined,
                    _nomineePhoneController,
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                // _buildTextField("Nominee Relation", Icons.group_outlined,
                //     _nomineeRelationController),
                _buildDropdown(
                  label: "Nominee Relation",
                  value: _getSafeNomineeRelationValue(),
                  items: const [
                    'Father',
                    'Mother',
                    'Brother',
                    'Sister',
                    'Husband',
                    'Wife',
                    'Son',
                    'Daughter',
                    'Other',
                  ],
                  onChanged: (val) {
                    setState(() {
                      _nomineeRelationController.text = val ?? '';
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Checkbox(
                    value: _acceptTnc,
                    onChanged: (value) {
                      setState(() => _acceptTnc = value ?? false);
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      showTermsAndConditionsDialog(context);
                    },
                    child: Text(
                      'Accept our Terms and Condition',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String? _getSafeNomineeRelationValue() {
    const validRelations = [
      'Father',
      'Mother',
      'Brother',
      'Sister',
      'Husband',
      'Wife',
      'Son',
      'Daughter',
      'Other',
    ];

    final current = _nomineeRelationController.text.trim();
    return validRelations.contains(current) ? current : null;
  }

  Widget _buildKYCSection() {
    print(_aadharController.text);
    print(_aadharFrontImage);
    print(_aadharBackImage);
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('KYC Documents (Mandatory)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Aadhar Number

            _buildTextField(
              "Aadhar Number*",
              Icons.numbers,
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
            const SizedBox(height: 16),

            // Aadhar Card Front

            _buildImageUploadField(
              label: "Aadhar Front*",
              imageFile: _aadharFrontImage,
              imageBytes: _aadharFrontImageBytes,
              onPressed: () => _pickImage(true, true),
              onRemove: () {
                setState(() {
                  _aadharFrontImage = null;
                  _aadharFrontImageBytes = null;
                });
              },
              isRequired: true,
            ),
            const SizedBox(height: 16),

            // Aadhar Card Back

            _buildImageUploadField(
              label: "Aadhar Back*",
              imageFile: _aadharBackImage,
              imageBytes: _aadharBackImageBytes,
              onPressed: () => _pickImage(true, false),
              onRemove: () {
                setState(() {
                  _aadharBackImage = null;
                  _aadharBackImageBytes = null;
                });
              },
              isRequired: true,
            ),
            const SizedBox(height: 16),

            // PAN Number

            _buildTextField(
              "PAN Number*",
              Icons.numbers,
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
            const SizedBox(height: 16),

            // PAN Card Image

            _buildImageUploadField(
              label: "PAN Card*",
              imageFile: _panCardImage,
              imageBytes: _panCardImageBytes,
              onPressed: () => _pickImage(false, null),
              onRemove: () {
                setState(() {
                  _panCardImage = null;
                  _panCardImageBytes = null;
                });
              },
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
    required VoidCallback onRemove,
    bool isRequired = false,
  }) {
    final bool hasImage = imageFile != null || imageBytes != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: !hasImage ? onPressed : null,
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: hasImage
                  ? null
                  : LinearGradient(
                      colors: [Colors.blue.shade50, Colors.blue.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              border: Border.all(
                color: (hasImage)
                    ? Colors.transparent
                    : (isRequired ? Colors.red : Colors.grey.shade400),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Image display
                if (imageBytes != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(imageBytes,
                        fit: BoxFit.contain, width: double.infinity),
                  )
                else if (imageFile != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(imageFile,
                        fit: BoxFit.cover, width: double.infinity),
                  )
                else
                  // Placeholder with trending style
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload,
                            size: 50, color: Colors.blue.shade400),
                        const SizedBox(height: 8),
                        Text(
                          "Tap to upload $label",
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Close Icon
                if (hasImage)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: onRemove,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (!hasImage && isRequired)
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              'This field is required',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  // Widget _buildMobileForm() {
  //   return Column(
  //     children: [
  //       // Scheme Type
  //       _buildDropdown(
  //         label: "Scheme Type",
  //         value: selectedSchemeType,
  //         items: schemeTypeList,
  //         onChanged: (val) => setState(() {
  //           selectedSchemeType = val;
  //           _generateCustomerId(val == "Wishlist" ? "WL" : "ASP");
  //         }),
  //       ),
  //       const SizedBox(height: 16),
  //       _buildCountryDropdown(),
  //       // Expanded(
  //       //   child: _buildDropdown(
  //       //     label: "Country",
  //       //     value: selectedCountry,
  //       //     items: countryList,
  //       //     onChanged: (val) => setState(() => selectedCountry = val),
  //       //   ),
  //       // ),
  //       const SizedBox(height: 16),
  //       _buildBranchDropdown(),
  //       const SizedBox(height: 16),

  //       // Customer Name
  //       _buildTextField("Customer Name", Icons.person_outline, _nameController,
  //           isRequired: true),
  //       const SizedBox(height: 16),

  //       // Customer ID
  //       _buildTextField("Customer ID", Icons.perm_identity, _custIdController,
  //           isReadOnly: true),
  //       // const SizedBox(height: 16),

  //       // // Order Advance Type
  //       // _buildDropdown(
  //       //   label: "Order Advance",
  //       //   value: selectedOdType,
  //       //   items: orderAdvList,
  //       //   onChanged: (val) => setState(() => selectedOdType = val),
  //       // ),
  //       const SizedBox(height: 16),

  //       // Phone Number
  //       _buildTextField(
  //         "Phone Number",
  //         Icons.phone_outlined,
  //         _phoneController,
  //         isRequired: true,
  //         keyboardType: TextInputType.phone,
  //         validator: (value) {
  //           if (value == null || value.isEmpty) return 'Required';
  //           if (value.length != 10) return 'Invalid phone number';
  //           return null;
  //         },
  //       ),
  //       const SizedBox(height: 16),

  //       // Address
  //       _buildTextField(
  //         "Address",
  //         Icons.home_outlined,
  //         _addressController,
  //         isRequired: true,
  //         maxLines: 3,
  //       ),
  //       const SizedBox(height: 16),

  //       // Country and Branch selection
  //       Row(
  //         children: [
  //           Expanded(
  //             child: _buildDropdown(
  //               label: "Country",
  //               value: selectedCountry,
  //               items: countryList,
  //               onChanged: (val) => setState(() => selectedCountry = val),
  //             ),
  //           ),
  //           const SizedBox(width: 16),
  //           Expanded(
  //             child: _buildDropdown(
  //               label: "Branch",
  //               value: selectedBranch,
  //               items: branchList,
  //               onChanged: (val) => setState(() => selectedBranch = val),
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 16),

  //       // Additional fields checkbox
  //       Row(
  //         children: [
  //           Checkbox(
  //             value: _showAdditionalFields,
  //             onChanged: (value) =>
  //                 setState(() => _showAdditionalFields = value ?? false),
  //           ),
  //           Text('Show Additional Fields'),
  //         ],
  //       ),
  //       const SizedBox(height: 10),

  //       // Additional fields (conditionally shown)
  //       if (_showAdditionalFields) ...[
  //         _buildTextField("Email", Icons.email_outlined, _emailController),
  //         const SizedBox(height: 16),
  //         _buildTextField(
  //             "Place", Icons.location_on_outlined, _placeController),
  //         const SizedBox(height: 16),
  //         _buildDateField("Date of Birth"),
  //         const SizedBox(height: 16),
  //         _buildTextField("Nominee", Icons.person_outline, _nomineeController),
  //         const SizedBox(height: 16),
  //         _buildTextField(
  //             "Nominee Phone", Icons.phone_outlined, _nomineePhoneController,
  //             keyboardType: TextInputType.phone),
  //         const SizedBox(height: 16),
  //         _buildTextField("Nominee Relation", Icons.group_outlined,
  //             _nomineeRelationController),
  //         const SizedBox(height: 16),
  //         _buildTextField("Aadhar Card", Icons.numbers, _aadharController),
  //         const SizedBox(height: 16),
  //         _buildTextField("PAN Card", Icons.numbers, _panController),
  //         const SizedBox(height: 16),
  //         _buildTextField("PIN Code", Icons.code, _pinCodeController,
  //             keyboardType: TextInputType.number),
  //         const SizedBox(height: 16),
  //       ],
  //     ],
  //   );
  // }
  Widget _buildMobileForm() {
    final bool isNewAccount = activeAccount == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Scheme Type
        _buildDropdown(
          label: "Scheme Type",
          value: selectedSchemeDisplay,
          items: schemeTypeList,
          onChanged: (val) {
            setState(() {
              selectedSchemeDisplay = val;

              if (val == "Wishlist - Bonus Scheme") {
                selectedSchemeType = "Wishlist";
                // _generateCustomerId("WL");
              } else if (val == "Aspire - Metal Scheme") {
                selectedSchemeType = "Aspire";
                // _generateCustomerId("ASP");
              }
            });
          },
        ),
        const SizedBox(height: 16),

        // Country and Branch
        _buildCountryDropdown(),
        const SizedBox(height: 16),
        _buildBranchDropdown(),
        const SizedBox(height: 16),

        // Customer Name (only for new accounts)
        if (isNewAccount) ...[
          _buildTextField(
            "Customer Name",
            Icons.person_outline,
            _nameController,
            isRequired: true,
          ),
          const SizedBox(height: 16),
        ],

        // Customer ID (only for new accounts)
        // if (isNewAccount) ...[
        //   _buildTextField(
        //     "Customer ID",
        //     Icons.badge_outlined,
        //     _custIdController,
        //     isReadOnly: true,
        //   ),
        //   const SizedBox(height: 16),
        // ],

        // Phone Number (only for new accounts)
        if (isNewAccount) ...[
          _buildTextField(
            "Phone Number",
            Icons.phone_outlined,
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
        ],

        // Aspire Scheme Quick Amount Chips
        if (selectedSchemeType == "Aspire") ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...[2000, 3000, 4000, 5000].map((amount) {
                  return ChoiceChip(
                    label: Text("₹$amount"),
                    selected: openingAmtCntrl.text == amount.toString(),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          openingAmtCntrl.text = amount.toString();
                        });
                      }
                    },
                  );
                }).toList(),
                // 👇 Custom amount input
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: openingAmtCntrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Custom",
                      prefixText: "₹ ",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        // clear chip selection when custom amount typed
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Scheme Amount
        _buildTextField(
          "Scheme Amount",
          Icons.attach_money,
          openingAmtCntrl,
          isRequired: true,
          isReadOnly: selectedSchemeType == "Aspire",
        ),
        const SizedBox(height: 8),

        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline,
                    size: 14, color: Colors.orange.shade600),
                const SizedBox(width: 4),
                Text(
                  "Minimum ₹2000",
                  style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Address (only for new accounts)
        if (isNewAccount) ...[
          _buildTextField(
            "Address",
            Icons.home_outlined,
            _addressController,
            isRequired: true,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
        ],

        // Pin Code (only for new accounts)
        if (isNewAccount) ...[
          _buildTextField(
            "Pin Code",
            Icons.pin_drop,
            _pinCodeController,
            isRequired: true,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
        ],

        // KYC (only for new accounts)
        if (isNewAccount) ...[
          _buildKYCSection(),
          const SizedBox(height: 20),
        ],

        // Additional Fields Checkbox (only for new accounts)
        if (isNewAccount) ...[
          Row(
            children: [
              Checkbox(
                value: _showAdditionalFields,
                onChanged: (value) =>
                    setState(() => _showAdditionalFields = value ?? false),
              ),
              const Text('Show Additional Fields'),
            ],
          ),
          const SizedBox(height: 10),
        ],

        // Additional Fields (only for new accounts)
        if (isNewAccount && _showAdditionalFields) ...[
          _buildTextField("Email", Icons.email_outlined, _emailController),
          const SizedBox(height: 16),
          _buildTextField(
              "Place", Icons.location_on_outlined, _placeController),
          const SizedBox(height: 16),
          _buildDateField("Date of Birth"),
          const SizedBox(height: 16),
          _buildTextField("Nominee", Icons.person_outlined, _nomineeController),
          const SizedBox(height: 16),
          _buildTextField(
              "Nominee Phone", Icons.phone_outlined, _nomineePhoneController,
              keyboardType: TextInputType.phone),
          const SizedBox(height: 16),

          // Nominee Relation Dropdown
          _buildDropdown(
            label: "Nominee Relation",
            value: _getSafeNomineeRelationValue(),
            items: const [
              'Father',
              'Mother',
              'Brother',
              'Sister',
              'Husband',
              'Wife',
              'Son',
              'Daughter',
              'Other',
            ],
            onChanged: (val) {
              setState(() {
                _nomineeRelationController.text = val ?? '';
              });
            },
          ),
          const SizedBox(height: 16),
        ],

        // Terms and Conditions
        Row(
          children: [
            Checkbox(
              value: _acceptTnc,
              onChanged: (value) {
                setState(() => _acceptTnc = value ?? false);
              },
            ),
            GestureDetector(
              onTap: () {
                showTermsAndConditionsDialog(context);
              },
              child: const Text(
                'Accept our Terms and Condition',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
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
    IconData icon,
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
        labelText: label + (isRequired ? '' : ''),
        filled: true,
        fillColor: Colors.grey[50],
        prefixIcon: Icon(icon, color: TColo.primaryColor1),
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

  _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          if (_isLoading) {
          } else {
            _submitForm();
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

  Future<void> _submitForm() async {
    if (_isLoading) return;

    // Validate form based on whether it's a new account or existing account update
    if (!_formKey.currentState!.validate()) {
      showErrorDialog(
        'Required',
        'Please fill all required fields correctly!',
        context,
      );
      return;
    }

    // Validate dropdown selections (always required)
    if (selectedSchemeType == null) {
      showErrorDialog(
        'Select Scheme',
        'Please select Scheme Type',
        context,
      );
      return;
    }

    // Validate country and branch selection (always required)
    if (selectedCountry == null || selectedBranch == null) {
      showErrorDialog(
        'Select Branch',
        'Please select both Country and Branch',
        context,
      );
      return;
    }

    // Validate scheme amount (always required)
    if (openingAmtCntrl.text.isEmpty) {
      showErrorDialog(
        'Opening Amount Required',
        'Please enter opening amount!',
        context,
      );
      return;
    } else if (double.parse(openingAmtCntrl.text) < 2000) {
      showErrorDialog(
        'Minimum Amount Required',
        'Opening amount cannot be less than 2000!',
        context,
      );
      return;
    }

    if (!_acceptTnc) {
      showErrorDialog(
          'Accept Tnc', 'Please accept Terms And Condition', context);
      return;
    }

    // For new accounts, validate KYC documents
    final bool isNewAccount = activeAccount == null;
    if (isNewAccount) {
      if (_aadharFrontImageBytes == null ||
          _aadharBackImageBytes == null ||
          _panCardImageBytes == null) {
        showErrorDialog(
          'Document required',
          'Please upload all required documents!',
          context,
        );
        return;
      }
    }

    // Save form data
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload images for new accounts only
      if (isNewAccount) {
        aadharFrontUrl = await _uploadImage(
          file: _aadharFrontImage,
          bytes: _aadharFrontImageBytes,
          path: '${_nameController.text}_aadhar_front.jpg',
        );

        aadharBackUrl = await _uploadImage(
          file: _aadharBackImage,
          bytes: _aadharBackImageBytes,
          path: '${_nameController.text}_aadhar_back.jpg',
        );

        panCardUrl = await _uploadImage(
          file: _panCardImage,
          bytes: _panCardImageBytes,
          path: '${_nameController.text}_pan_card.jpg',
        );

        // Check if image uploads were successful
        if (aadharFrontUrl == null ||
            aadharBackUrl == null ||
            panCardUrl == null) {
          throw 'Failed to upload one or more images';
        }
      }

      if (widget.type != "add") {
        // UPDATE EXISTING ACCOUNT
        print("------- update --------");

        final activeAccount = context.read<AccountProvider>().currentAccount;

        if (activeAccount != null && activeAccount.id != null) {
          // Prepare update data
          final updateData = {
            "schemeType": selectedSchemeType!,
            "openingAmount": double.parse(openingAmtCntrl.text),
            "branch": selectedBranchObject?.id ?? '',
            "branchName": selectedBranch ?? '',
            "country": selectedCountry ?? '',
            "updatedDate": DateTime.now(),
          };

          // Only include KYC fields if they were updated
          if (_aadharController.text.isNotEmpty) {
            updateData["adharCard"] = _aadharController.text;
          }
          if (_panController.text.isNotEmpty) {
            updateData["panCard"] = _panController.text;
          }
          if (_pinCodeController.text.isNotEmpty) {
            updateData["pinCode"] = _pinCodeController.text;
          }

          // Update existing Firestore doc
          await FirebaseFirestore.instance
              .collection('schemeusers')
              .doc(activeAccount.id)
              .update(updateData);

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
      } else {
        // CREATE NEW ACCOUNT
        print("------- add --------");

        final user = SchemeUserModel(
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
            status: CustomerStatus.pending);

        print(user.toMap().toString());

        // Add document (auto-generated ID by Firestore)
        final docRef =
            await FirebaseFirestore.instance.collection('schemeusers').add({
          ...user.toMap(),
          "createdDate": FieldValue.serverTimestamp(),
          "updatedDate": FieldValue.serverTimestamp(),
        });

        print(_phoneController.text);
        final querySnapshot = await FirebaseFirestore.instance
            .collection('user')
            .where('phoneNo', isEqualTo: _phoneController.text)
            .limit(1) // assuming phoneNo is unique
            .get();
        print("==============");
        print(querySnapshot.docs.length);
        if (querySnapshot.docs.isNotEmpty) {
          final docId = querySnapshot.docs.first.id;

          await FirebaseFirestore.instance
              .collection('user')
              .doc(docId)
              .update({
            'name': _nameController.text,
            "branch": selectedBranchObject?.id,
            "branchName": selectedBranch
          });

          print("✅ User name updated successfully");
        }

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

        final screenWidth = MediaQuery.of(context).size.width;
        _showRightSnackBar(
            context, "Scheme Registration Succefully..", Colors.green);
      }
      context.read<AccountProvider>().loadAccounts(_phoneController.text);
    } catch (err) {
      print('Error: $err');
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'Failed to ${widget.type != "add" ? "update" : "create"} customer: $err'),
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
          _isLoading = false;
        });
      }
    }
  }

  void _showRightSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    final screenWidth = MediaQuery.of(context).size.width;
    final snackbarWidth = 400.0; // Fixed width for the snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          width: snackbarWidth,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(message),
          ),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.7,
            bottom: 16,
            right: 16),
      ),
    );
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
