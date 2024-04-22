import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/faq_model.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: FadeIn(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(
              height: height(context) * 0.08,
            ),
            Row(
              children: [
                InkWell(                    borderRadius: BorderRadius.circular(20),

                  onTap: () => popNav(context),
                  child: Icon(
                    Icons.chevron_left,
                    size: 29,
                    color: lightGradient,
                  ),
                ),
                10.width,
                Text(
                  "FAQ",
                  style: GoogleFonts.readexPro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: lightGradient),
                ),
              ],
            ),
            SizedBox(
              height: height(context) * 0.02,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                return FAQWidget(faq: faqs[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FAQWidget extends StatefulWidget {
  final FAQ faq;

  FAQWidget({required this.faq});

  @override
  _FAQWidgetState createState() => _FAQWidgetState();
}

class _FAQWidgetState extends State<FAQWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          
          title: Text(widget.faq.question),
          trailing: Icon(_isExpanded ? Icons.remove : Icons.add),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.only(bottom:10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    widget.faq.answer.map((answer) => Text('• $answer')).toList(),
              ),
          ),
          
      ],
    );
  }
}
