import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/promo_code_old.dart';

class PaymentContainer extends StatelessWidget {
  Function()? onTap;

  Services? promoCode;
  PaymentContainer({
    required this.onTap,
    Key? key,
    this.promoCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: lightGray),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              FontAwesomeIcons.ccVisa,
              color: Utils().lightBlue,
              size: 40,
            ),
            title: Text(
              'Personal',
              // ignore: deprecated_member_use
              style: myFont28_600,
            ),
            subtitle: const Text(
              'show saved card',
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: gray,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
                leading: Icon(
                  FontAwesomeIcons.bank,
                  color: Utils().lightBlue,
                  size: 40,
                ),
                title: Text(
                  'Add Credit or Debit Cards', style: myFont28_600,
                  // ignore: deprecated_member_use
                ),
                trailing: TextButton(
                    onPressed: onTap,
                    child: Text(
                      'add'.toUpperCase(),
                      style: myFont28_600.copyWith(color: Utils().lightBlue),
                    ))),
          ),
        ],
      ),
    );
  }
}
