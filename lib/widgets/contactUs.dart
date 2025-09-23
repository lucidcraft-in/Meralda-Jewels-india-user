// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, avoid_print

library contactus;

// import 'package:model/custom_field.dart';
// import 'package:contact_us/core/base/colorStyles.dart';
import 'package:flutter/material.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/custom_field.dart';

///Class for adding contact details/profile details as a complete new page in your flutter app.
class ContactUs extends StatelessWidget {
  ///Logo of the Company/individual
  final ImageProvider? logo;

  ///Ability to add an image
  final Image? image;

  ///Phone Number of the company/individual
  final String? phoneNumber;

  ///Text for Phonenumber
  final String? phoneNumberText;

  ///Website of company/individual
  final String? website;

  ///Text for Website
  final String? websiteText;

  ///Email ID of company/individual
  final String email;

  ///Text for Email
  final String? emailText;

  ///Twitter Handle of Company/Individual
  final String? twitterHandle;

  ///Facebook Handle of Company/Individual
  final String? facebookHandle;

  ///Linkedin URL of company/individual
  final String? linkedinURL;

  ///Github User Name of the company/individual
  final String? githubUserName;

  ///Tiktok URL of the comapny/individual
  final String? tiktokUrl;

  ///Name of the Company/individual
  final String companyName;

  ///Font size of Company name
  final double? companyFontSize;

  ///TagLine of the Company or Position of the individual
  final String? tagLine;

  ///Instagram User Name of the company/individual
  final String? instagram;

  ///TextColor of the text which will be displayed on the card.
  final Color textColor;

  ///Color of the Card.
  final Color cardColor;

  ///Color of the company/individual name displayed.
  final Color companyColor;

  ///Color of the tagLine of the Company/Individual to be displayed.
  final Color taglineColor;

  /// font of text
  final String? textFont;

  /// font of the company/individul to be displayed
  final String? companyFont;

  /// font of the tagline to be displayed
  final String? taglineFont;

  /// divider color which is placed between the tagline & contact informations
  final Color? dividerColor;

  /// divider thickness which is placed between the tagline & contact informations

  final double? dividerThickness;

  ///font weight for tagline and company name
  final FontWeight? companyFontWeight;
  final FontWeight? taglineFontWeight;

  /// avatar radius will place the circularavatar according to developer/UI need
  final double? avatarRadius;

  /// a list of [CustomSocialField] which can be used to add custom socials which are
  /// not offered by default parameters
  final List<CustomSocialField>? customSocials;

  ///Constructor which sets all the values.
  const ContactUs({
    super.key,
    required this.companyName,
    required this.textColor,
    required this.cardColor,
    required this.companyColor,
    required this.taglineColor,
    required this.email,
    this.emailText,
    this.logo,
    this.image,
    this.phoneNumber,
    this.phoneNumberText,
    this.website,
    this.websiteText,
    this.twitterHandle,
    this.facebookHandle,
    this.linkedinURL,
    this.githubUserName,
    this.tiktokUrl,
    this.tagLine,
    this.instagram,
    this.companyFontSize,
    this.textFont,
    this.companyFont,
    this.taglineFont,
    this.dividerColor,
    this.companyFontWeight,
    this.taglineFontWeight,
    this.avatarRadius,
    this.dividerThickness,
    this.customSocials,
  });

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 8.0,
          contentPadding: EdgeInsets.all(18.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => launchUrl(Uri.parse('tel:' + phoneNumber!)),
                  child: Container(
                    height: 50.0,
                    alignment: Alignment.center,
                    child: Text('Call'),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () => launchUrl(Uri.parse('sms:' + phoneNumber!)),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Text('Message'),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    final url = Uri.parse(
                      'https://wa.me/' +
                          phoneNumber!.substring(
                            1,
                            phoneNumber!.length,
                          ),
                    );
                    // print(url);
                    launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Text('WhatsApp'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                width: 200,
                image: AssetImage(
                    "assets/images/WhatsApp_Image_2024-06-29_at_11.09.35_AM-removebg-preview.png")),
            Visibility(
                visible: image != null, child: image ?? SizedBox.shrink()),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              color: dividerColor ?? Colors.teal[200],
              thickness: dividerThickness ?? 2.0,
              indent: 50.0,
              endIndent: 50.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            Visibility(
              visible: website != null,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.location_city,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      "Prakash Jewellery Main Road Perambra Kozhikode Kerala Pin 673525",
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontFamily: textFont,
                          fontSize: 13),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Typicons.link,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      websiteText ?? website!,
                      style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontFamily: textFont,
                          fontSize: 13),
                    ),
                    onTap: () => launchUrl(Uri.parse(website!)),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      phoneNumberText ?? phoneNumber!,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: textFont,
                          fontSize: 13),
                    ),
                    onTap: () => showAlert(context),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.mark_email_read_sharp,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      emailText ?? email,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: textFont,
                          fontSize: 13),
                    ),
                    onTap: () => launchUrl(Uri.parse('mailto:' + email)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///Class for adding contact details of the developer in your bottomNavigationBar in your flutter app.
class ContactUsBottomAppBar extends StatelessWidget {
  ///Color of the text which will be displayed in the bottomNavigationBar
  final Color textColor;

  ///Color of the background of the bottomNavigationBar
  final Color backgroundColor;

  ///Email ID Of the company/developer on which, when clicked by the user, the respective mail app will be opened.
  final String email;

  ///Name of the company or the developer
  final String companyName;

  ///Size of the font in bottomNavigationBar
  final double fontSize;

  /// font of text
  final String? textFont;

  const ContactUsBottomAppBar({
    super.key,
    required this.textColor,
    required this.backgroundColor,
    required this.email,
    required this.companyName,
    this.fontSize = 15.0,
    this.textFont,
  });
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        disabledForegroundColor: Colors.grey.withOpacity(0.38),
        shadowColor: Colors.transparent,
      ),
      child: Text(
        'Designed and Developed by $companyName 💙\nWant to contact?',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: textColor, fontSize: fontSize, fontFamily: textFont),
      ),
      onPressed: () => launchUrl(Uri.parse('mailto:$email')),
    );
  }
}
