import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meralda_gold_user/common/colo_extension.dart';
import 'package:meralda_gold_user/web/webBasicRag.dart';
import 'package:meralda_gold_user/web/webPayScreen.dart';
import 'package:meralda_gold_user/web/widgets/calculator.dart';
import 'package:meralda_gold_user/web/widgets/columnUi.dart';
import 'package:meralda_gold_user/web/widgets/footerSection.dart';
import 'package:meralda_gold_user/web/widgets/jewelleryLocations.dart';
import 'package:meralda_gold_user/web/widgets/planeSpec.dart';
import 'package:meralda_gold_user/web/widgets/schemCard.dart';
import 'package:meralda_gold_user/web/widgets/webgoldRate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'helperWidget.dart/switchCountry.dart';
import 'wbLogin/sendOtp.dart';
import 'webLogin.dart';
import 'webProfile.dart';

class WebHomeScreen extends StatefulWidget {
  @override
  _WebHomeScreenState createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late VideoPlayerController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isMuted = true;
  String _selectedFlag = "india";
  @override
  void initState() {
    super.initState();
    _initAnimations();
    loadUserLocally();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _controller = VideoPlayerController.asset(
        "assets/video/22e3a57cf3f14787ba9cfc940d6f56c7.mp4")
      ..initialize().then((_) {
        setState(() {}); // refresh
        _controller.setLooping(true);
        _controller.setVolume(0); // start muted
        _controller.play();
      });
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
  }

  String _userName = "";

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  var user;
  Future loadUserLocally() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.containsKey("user")) {
      var userData = pref.getString("user");

      if (userData != null) {
        user = json.decode(userData);

        setState(() {
          _userName = user['id'] ?? '';
        });
      }
    } else {
      showLoginDialog(context);
      setState(() {
        _userName = '';
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Determine layout based on screen width
            final screenWidth = constraints.maxWidth;
            final isLargeScreen = screenWidth > 1200;
            final isMediumScreen = screenWidth > 800;
            final isSmallScreen = screenWidth > 600;
            final isExtraSmallScreen = screenWidth <= 400;

            return SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    _buildAppBar(isLargeScreen, isMediumScreen, isSmallScreen,
                        isExtraSmallScreen),
                    // _buildWelcomeMessage(),
                    _buildContent(context, isLargeScreen, isMediumScreen,
                        isSmallScreen, user),
                    CustomFooter()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isLargeScreen,
      bool isMediumScreen, bool isSmallScreen, var userData) {
    return Container(
      // constraints: BoxConstraints(
      //   maxWidth: isLargeScreen ? 1200 : (isMediumScreen ? 800 : 600),
      // ),
      padding: EdgeInsets.symmetric(
        horizontal: isLargeScreen ? 40 : (isMediumScreen ? 15 : 10),
        vertical: 10,
      ),
      child: Column(
        children: [
          _buildNewArrivalBanner(),
          SizedBox(height: 20),
          // SsuranceContainer(),
          RightSideImgSchemeCard(
            userName: _userName,
          ),
          // SizedBox(height: 20), GoldCalculatorScreen(),
          SizedBox(height: 20),
          LeftSideImgSchemeCard(
            username: _userName,
            user: user,
          ),

          // _buildSubscriptionPlans(
          //     context, isLargeScreen, isMediumScreen, isSmallScreen),
          // SizedBox(height: 20),
          // _buildGoldRates(isMediumScreen),

          // SizedBox(height: 20),
          // _buildQuickAccess(context, isMediumScreen, userData),
          SizedBox(height: 20),
          HowItWorksSection(),

          SizedBox(height: 20),
          GoldRateSection(),
          SizedBox(height: 20),
          // _buildStoreInfo(),
          LocationSection(),
          SizedBox(height: 20),

          SizedBox(height: 20),

          // _buildFeaturedProducts(context, isMediumScreen),
          // SizedBox(height: 20),
          // _buildCategories(context, isMediumScreen),
          // SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSubscriptionPlans(BuildContext context, bool isLargeScreen,
      bool isMediumScreen, bool isSmallScreen) {
    return Container(
      height: isLargeScreen ? 1450 : 2100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Choose Your Plan',
              style: TextStyle(
                fontFamily: "arsenica",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
          ),
          SizedBox(height: 20),
          isLargeScreen
              ? Column(
                  children: [
                    _buildPlanSpecificsCard(isSmallScreen),
                    SizedBox(height: 15),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildWishListCard()),
                          SizedBox(width: 15),
                          Expanded(
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 1.5,
                                child: _buildAspireCard()),
                          )
                          // Expanded(child: _buildAspireCard()),
                        ],
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    _buildPlanSpecificsCard(isSmallScreen),
                    SizedBox(height: 15),
                    _buildWishListCard(),
                    SizedBox(height: 15),
                    Container(
                        height: MediaQuery.of(context).size.height * 1.5,
                        child: _buildAspireCard())
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildPlanSpecificsCard(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(color: Color(0xFF1B5E20).withOpacity(0.2), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.list_alt, color: Colors.white, size: 24),
              ),
              SizedBox(width: 15),
              Text(
                'Plan Specifics',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildPlanFeature(
              'Enrollment',
              'Enroll anywhere with Meralda sales representative',
              'Installment',
              'Fixed monthly payments, cannot be changed'),
          _buildPlanFeature(
              'Payment Options',
              'Cash, cards, cheque, and UPI accepted',
              'Post Maturity',
              'Full reimbursement without benefits if not redeemed'),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColo.primaryColor1,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: Text(
                'Learn More',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishListCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: Color(0xFF1B5E20).withOpacity(0.2), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Container(
              width: 160,
              child: Image(image: AssetImage("assets/photos/wishlist.png"))),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.offline_bolt,
                          color: TColo.primaryColor1,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Get up to 100% of first installment as Bonus',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.offline_bolt,
                          color: TColo.primaryColor1,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Easy Monthly Installments',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'With the WishList Jewellery Buying Plan, we love to turn your desires into reality. Now, you can open an account with a minimum amount of 2000.You will be qualified for a bonus of up to 100% of your initial instalment, if you make fixed monthly payments for 11 months continuously.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: SchemeTableScreen(),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_userName != "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Webprofile(),
                    ),
                  );
                } else {
                  showLoginDialog(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColo.primaryColor1,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: Text(
                'Subscribe to WishList',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildAspireCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: Color(0xFF1B5E20).withOpacity(0.2), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Container(
              width: 160,
              child: Image(image: AssetImage("assets/photos/aspire.png"))),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.offline_bolt,
                          color: TColo.primaryColor1,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Get Advantage of Average Gold Rate',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.offline_bolt,
                          color: TColo.primaryColor1,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Easy Monthly Installments',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Meralda Aspire Jewellery Buying Plan is a gateway to own coveted pieces by paying fixed instalment starting from only ₹2000 for 11 months. Each payment reserves a portion of gold weight equivalent to the amount paid and, at the time of redemption, you can get your jewellery equivalent to the accumulated weight without paying any making charges up to 16%.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(child: GoldBookingTable()),
              ),
            ],
          )),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_userName != "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Webprofile(),
                    ),
                  );
                } else {
                  showLoginDialog(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColo.primaryColor1,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: Text(
                'Subscribe to Aspire',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildPlanFeature(
    String title1,
    String description1,
    String title2,
    String description2,
  ) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Left side
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: EdgeInsets.only(top: 6, right: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF1B5E20),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF1B5E20),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        description1,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 10),

          /// Right side
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: EdgeInsets.only(top: 6, right: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF1B5E20),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF1B5E20),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        description2,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishListOption(String amount, String duration) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            amount,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.orange[800],
            ),
          ),
          Text(
            duration,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(bool isLargeScreen, bool isMediumScreen,
      bool isSmallScreen, bool isExtraSmallScreen) {
    // Calculate sizes based on screen dimensions
    double logoHeight = isLargeScreen
        ? MediaQuery.of(context).size.height * .15
        : isMediumScreen
            ? MediaQuery.of(context).size.height * .12
            : isSmallScreen
                ? MediaQuery.of(context).size.height * .10
                : MediaQuery.of(context).size.height * .08;

    double iconSize = isLargeScreen
        ? 24
        : isMediumScreen
            ? 20
            : isSmallScreen
                ? 18
                : 16;
    double rightPadding = isLargeScreen
        ? 50
        : isMediumScreen
            ? 30
            : isSmallScreen
                ? 20
                : 10;
    double spacing = isLargeScreen
        ? 20
        : isMediumScreen
            ? 15
            : isSmallScreen
                ? 10
                : 8;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: isLargeScreen
          ? MediaQuery.of(context).size.height * .2
          : isMediumScreen
              ? MediaQuery.of(context).size.height * .18
              : isSmallScreen
                  ? MediaQuery.of(context).size.height * .16
                  : MediaQuery.of(context).size.height * .14,
      decoration: BoxDecoration(color: TColo.primaryColor1),
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                "assets/images/logo_bg_white.png",
                height: logoHeight,
                fit: BoxFit
                    .contain, // Changed from fill to contain for better aspect ratio
              ),
            ),
            Positioned(
              top: isLargeScreen
                  ? 10
                  : isMediumScreen
                      ? 8
                      : isSmallScreen
                          ? 6
                          : 4,
              right: rightPadding,
              child: Container(
                height: isLargeScreen
                    ? 100
                    : isMediumScreen
                        ? 80
                        : isSmallScreen
                            ? 60
                            : 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Country Dropdown with responsive sizing
                    Container(
                      width: isLargeScreen
                          ? 120
                          : isMediumScreen
                              ? 100
                              : isSmallScreen
                                  ? 100
                                  : 100,
                      child: CountryDropDown(),
                    ),
                    SizedBox(width: spacing),

                    SizedBox(width: spacing),
                    GestureDetector(
                      onTap: () {
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebPayAmountScreen(
                                custName: _userName,
                                userid: user["id"],
                                user: user,
                              ),
                            ),
                          );
                        } else {
                          showLoginDialog(context);
                        }
                      },
                      child: Icon(
                        FontAwesomeIcons.userTie,
                        color: TColo.primaryColor2,
                        size: iconSize,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      color: TColo.primaryColor2,
      child: Text(
        'Welcome Back, ${_userName}',
        style: TextStyle(
          color: TColo.primaryColor1,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStoreInfo() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [TColo.primaryColor1, TColo.primaryColor1],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.store, color: Colors.white, size: 30),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meralda Jewels',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Mavoor Rd, near Arayidathupalam, Parayancheri, Puthiyara, Kozhikode',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.shopping_bag, color: Colors.orange[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewArrivalBanner() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        return Container(
            child: _controller.value.isInitialized
                ? Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: Icon(
                              _isMuted ? Icons.volume_off : Icons.volume_up,
                              color: Colors.white,
                            ),
                            onPressed: _toggleMute,
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    height: 200,
                    color: Colors.black12,
                    child: Center(child: CircularProgressIndicator()),
                  ));
      },
    );
  }

  Widget _buildWideBannerContent() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                'ARRIVAL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'JUST FOR YOU',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                color: Colors.white.withOpacity(0.1),
              ),
              child: Icon(Icons.diamond, color: Colors.white, size: 45),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Text(
                      'SAVE UP TO',
                      style: TextStyle(
                        color: Color(0xFF1B5E20),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '30% OFF',
                      style: TextStyle(
                        color: Color(0xFF1B5E20),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNarrowBannerContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'New ARRIVAL',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        Text(
          'JUST FOR YOU',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            color: Colors.white.withOpacity(0.1),
          ),
          child: Icon(Icons.diamond, color: Colors.white, size: 35),
        ),
        SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                Text(
                  'SAVE UP TO',
                  style: TextStyle(
                    color: Color(0xFF1B5E20),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
                Text(
                  '30% OFF',
                  style: TextStyle(
                    color: Color(0xFF1B5E20),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWideGoldRates() {
    return Row(
      children: [
        Expanded(
          child: _buildGoldRateCard(
              '22 Karat', '1 Gram', '₹9100', Colors.yellow[700]!),
        ),
        SizedBox(width: 15),
        Expanded(
          child: _buildGoldRateCard(
              '22 Karat', '8 Gram', '₹72800', Colors.orange[700]!),
        ),
        SizedBox(width: 15),
        Expanded(
          child: _buildGoldRateCard(
              '18 Karat', '1 Gram', '₹70000', Colors.amber[700]!),
        ),
      ],
    );
  }

  Widget _buildNarrowGoldRates() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildGoldRateCard(
                  '22 Karat', '1 Gram', '₹9100', Colors.yellow[700]!),
            ),
            SizedBox(width: 15),
            Expanded(
              child: _buildGoldRateCard(
                  '22 Karat', '8 Gram', '₹72800', Colors.orange[700]!),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildGoldRateCard(
                  '18 Karat', '1 Gram', '₹70000', Colors.amber[700]!),
            ),
            SizedBox(width: 15),
            Expanded(child: Container()), // Empty container for spacing
          ],
        ),
      ],
    );
  }

  Widget _buildGoldRateCard(
      String karat, String weight, String price, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/login');
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.star, color: color, size: 24),
            ),
            SizedBox(height: 8),
            Text(
              karat,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF1B5E20),
              ),
            ),
            Text(
              weight,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            SizedBox(height: 5),
            Text(
              price,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1B5E20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedProducts(BuildContext context, bool isMediumScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Products',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: Color(0xFF1B5E20),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: isMediumScreen ? 2 : 1,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: isMediumScreen ? 0.8 : 1.2,
          children: [
            _buildProductCard(
                "assets/photos/arteum-ro-VJZdxfvFGuo-unsplash.jpg",
                'Diamond necklace',
                'NE001',
                '8 gram',
                Icons.diamond,
                Colors.blue,
                context),
            _buildProductCard(
                "assets/photos/kateryna-hliznitsova-ceSCZzjTReg-unsplash.jpg",
                'Earrings',
                'MCV005',
                '2 pieces',
                Icons.diamond,
                Colors.purple,
                context),
            _buildProductCard(
                "assets/photos/pexels-leah-newhouse-50725-691046.jpg",
                'Gold Earrings',
                'MW100',
                '2 gram',
                Icons.diamond,
                Colors.orange,
                context),
            _buildProductCard(
                "assets/photos/pexels-martabranco-1395306.jpg",
                'Bangle',
                'MC004',
                '4 pieces',
                Icons.circle,
                Colors.green,
                context),
          ],
        ),
      ],
    );
  }

  Widget _buildProductCard(String image, String name, String code,
      String weight, IconData icon, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/login');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                    ),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: Image(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1B5E20),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 5),
                      Text(
                        code,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    weight,
                    style: TextStyle(
                      color: Color(0xFF1B5E20),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context, bool isMediumScreen) {
    return Column(
      children: [
        Text(
          'Categories',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        SizedBox(height: 20),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.spaceEvenly,
          children: [
            _buildCategoryItem("assets/icons/1.png", 'Ring', Icons.diamond,
                Colors.blue, context),
            _buildCategoryItem("assets/icons/2.png", 'Necklace', Icons.diamond,
                Colors.purple, context),
            _buildCategoryItem("assets/icons/3.png", 'Earrings', Icons.circle,
                Colors.orange, context),
            _buildCategoryItem("assets/icons/4.png", 'Diamond Ring',
                Icons.circle_outlined, Colors.green, context),
            _buildCategoryItem("assets/icons/5.png", 'necklaces', Icons.diamond,
                Colors.blue, context),
            _buildCategoryItem("assets/icons/6.png", 'earrings', Icons.diamond,
                Colors.purple, context),
            _buildCategoryItem("assets/icons/7.png", 'rings', Icons.circle,
                Colors.orange, context),
            _buildCategoryItem("assets/icons/8.png", 'bangles',
                Icons.circle_outlined, Colors.green, context),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String image, String name, IconData icon,
      Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/login');
      },
      child: Column(
        children: [
          Container(
              width: 70,
              height: 70,
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //     colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              //   ),
              //   shape: BoxShape.circle,
              //   border: Border.all(color: color.withOpacity(0.3), width: 2),
              // ),
              child: Image(image: AssetImage(image))),
          SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1B5E20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccess(
      BuildContext context, bool isMediumScreen, var userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        SizedBox(height: 20),
        isMediumScreen
            ? _buildWideQuickAccess(context)
            : _buildNarrowQuickAccess(context, userData),
      ],
    );
  }

  Widget _buildWideQuickAccess(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickAccessCard(
            context,
            'Pay Now',
            Icons.payment,
            [Colors.pink[300]!, Colors.pink[100]!],
            Colors.pink[700]!,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: _buildQuickAccessCard(
            context,
            'View Transaction',
            Icons.receipt_long,
            [Colors.green[300]!, Colors.green[100]!],
            Colors.green[700]!,
            isTwoLines: true,
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowQuickAccess(BuildContext context, var userData) {
    return Column(
      children: [
        _buildQuickAccessCard(context, 'Pay Now', Icons.payment,
            [Colors.pink[300]!, Colors.pink[100]!], Colors.pink[700]!,
            userData: userData),
        SizedBox(height: 15),
        _buildQuickAccessCard(context, 'View Transaction', Icons.receipt_long,
            [Colors.green[300]!, Colors.green[100]!], Colors.green[700]!,
            isTwoLines: true, userData: userData),
      ],
    );
  }

  Widget _buildQuickAccessCard(BuildContext context, String title,
      IconData icon, List<Color> gradientColors, Color iconColor,
      {bool isTwoLines = false, var userData}) {
    return GestureDetector(
      onTap: () {
        // if (title == "View Transaction") {
        // if (user != null) {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => CustomerInvestmentWebScreen()));
        // } else {
        //   _showLoginDialog(context);
        //   // ScaffoldMessenger.of(context).showSnackBar(
        //   //   SnackBar(content: Text("Customer ID is required")),
        //   // );
        // }
        // } else {
        if (_userName != "") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebPayAmountScreen(
                custName: _userName,
                userid: user["id"],
                user: user,
              ),
            ),
          );
        } else {
          showLoginDialog(context);
        }
        // }
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 25),
            ),
            SizedBox(width: 15),
            if (isTwoLines)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'View',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  Text(
                    'Transaction',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              )
            else
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF1B5E20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void showLoginDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    // barrierDismissible: false,
    barrierLabel: 'Login',
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Stack(
        children: [
          // Blurred background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Center(
            child: Material(
              color: Colors.transparent,
              // child: WebLoginpage(),
              child: MobileNumberScreen(),
            ),
          ),
        ],
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
