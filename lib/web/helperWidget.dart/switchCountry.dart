import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CountryDropDown extends StatefulWidget {
  const CountryDropDown({super.key});

  @override
  State<CountryDropDown> createState() => _CountryDropDownState();
}

class _CountryDropDownState extends State<CountryDropDown> {
  String _selectedCountry = "India";
  List<Map<String, String>> _countries = [
    {
      "name": "India",
      "flag": "assets/photos/india flag.png",
      "code": "IN",
      "url": "https://meralda-gold-9ff64.web.app"
    },
    {
      "name": "United Arab Emirates",
      "flag": "assets/photos/uaeflag.png",
      "code": "UAE",
      "url": ""
    },

    // Add more countries as needed
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      // decoration: BoxDecoration(
      //   color: Colors.white.withOpacity(0.1),
      //   borderRadius: BorderRadius.circular(8),
      //   border: Border.all(color: TColo.primaryColor2.withOpacity(0.3)),
      // ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCountry,
          icon: Icon(
            Icons.arrow_drop_down,
            color: TColo.primaryColor2,
            size: 20,
          ),
          dropdownColor: TColo.primaryColor1,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          items: _countries.map((country) {
            return DropdownMenuItem<String>(
              value: country["name"],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      country["flag"]!,
                      width: 20,
                      height: 15,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 20,
                          height: 15,
                          color: Colors.grey,
                          child: Icon(
                            Icons.flag,
                            size: 10,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    country["code"]!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCountry = newValue!;
            });
            // Handle country change logic here
            _onCountryChanged(newValue!);
          },
        ),
      ),
    );
  }

  void _onCountryChanged(String selectedCountry) {
    // Find the selected country details
    Map<String, String>? countryData = _countries.firstWhere(
      (country) => country["name"] == selectedCountry,
      orElse: () => _countries[0],
    );

    // If URL exists, open it in WebView (replace current tab)
    if (countryData["url"] != null && countryData["url"]!.isNotEmpty) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => CountryWebView(
            url: countryData["url"]!,
            title: countryData["name"]!,
          ),
        ),
        (Route<dynamic> route) => false, // 🔑 removes back stack
      );
    }
  }
}

class CountryWebView extends StatelessWidget {
  final String url;
  final String title;

  const CountryWebView({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // 🔑 No back button
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
