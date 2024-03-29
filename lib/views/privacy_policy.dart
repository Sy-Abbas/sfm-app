import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Privacy Policy",
          style: TextStyle(
              color: const Color(0xff05240E),
              fontSize: MediaQuery.of(context).size.width * 0.065,
              fontFamily: "RobotoBold"),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xff05240E),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                height: 200,
                child: OverflowBox(
                  minHeight: 550,
                  maxHeight: 550,
                  child: Lottie.asset(
                    "assets/animation/privacy-policy.json",
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16,
                ),
                child: Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    color: Color(0xff05240E),
                    fontFamily: 'RobotoBold',
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.only(left: 16.0, right: 16, top: 5, bottom: 5),
                child: Text(
                  'By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages or make derivative versions. The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, still belong to Syed Abbas Hussain.\nSyed Abbas Hussain is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.\nThe Surplus Food Management app stores and processes personal data that you have provided to us, to provide my Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the Surplus Food Management app won’t work properly or at all.\nThe app does use third-party services that declare their Terms and Conditions. Link to Terms and Conditions of third-party service providers used by the app:',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 42.0, right: 16, top: 5, bottom: 5),
                child: GestureDetector(
                  onTap: () async {
                    final Uri url =
                        Uri.parse('https://policies.google.com/terms');
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '•	Google Play Services',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontFamily: "Roboto"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 42.0, right: 16, top: 5, bottom: 5),
                child: GestureDetector(
                  onTap: () async {
                    final Uri url = Uri.parse(
                        'https://firebase.google.com/terms/analytics');
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '•	Google Analytics for Firebase',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontFamily: "Roboto"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.only(left: 16.0, right: 16, top: 5, bottom: 5),
                child: Text(
                  'You should be aware that there are certain things that Syed Abbas Hussain will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi or provided by your mobile network provider, but Syed Abbas Hussain cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left.\nIf you’re using the app outside of an area with Wi-Fi, you should remember that the terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third-party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app.\nAlong the same lines, Syed Abbas Hussain cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, Syed Abbas Hussain cannot accept responsibility.\nWith respect to Syed Abbas Hussain’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavor to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. Syed Abbas Hussain accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.\nAt some point, we may wish to update the app. The app is currently available on Android – the requirements for the system(and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. Syed Abbas Hussain does not promise that it will always update the app so that it is relevant to you and/or works with the Android version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device.',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.0,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16,
                  top: 12,
                ),
                child: Text(
                  'Changes to Terms and Conditions',
                  style: TextStyle(
                    color: Color(0xff05240E),
                    fontFamily: 'RobotoBold',
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.only(left: 16.0, right: 16, top: 5, bottom: 5),
                child: Text(
                  'I may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Terms and Conditions on this page. These terms and conditions are effective as of 2023-04-03.',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.0,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16,
                  top: 12,
                ),
                child: Text(
                  'Contact Us',
                  style: TextStyle(
                    color: Color(0xff05240E),
                    fontFamily: 'RobotoBold',
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 5, bottom: 5),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text:
                            'If you have any questions or suggestions about my Terms and Conditions, do not hesitate to contact me at ',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      TextSpan(
                          text: 'surplusfoodmanagement@gmail.com.',
                          style: const TextStyle(
                              color: Colors.green, fontSize: 16),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: 'surplusfoodmanagement@gmail.com',
                              );
                              launchUrl(emailLaunchUri);
                            }),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
