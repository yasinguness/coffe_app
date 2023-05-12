import 'package:coffe_app/common/constants/coffee_colors.dart';
import 'package:coffe_app/common/constants/coffee_padding.dart';
import 'package:coffe_app/common/constants/router_constants.dart';
import 'package:coffe_app/common/constants/text_const.dart';
import 'package:coffe_app/common/widgets/app_bar_widget.dart';
import 'package:coffe_app/common/widgets/background_decoration.dart';
import 'package:coffe_app/network/models/product/product.dart';
import 'package:coffe_app/ui/checkout/view/checkout_view.dart';
import 'package:flutter/material.dart';

class SweetTreatsWidget extends StatefulWidget {
  final ProductModel? coffee;
  const SweetTreatsWidget({
    super.key,
    this.coffee,
  });

  @override
  State<SweetTreatsWidget> createState() => _SweetTreatsWidgetState();
}

class _SweetTreatsWidgetState extends State<SweetTreatsWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          _buildBackground(),
          //TreatsListView(coffee: widget.coffee!),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: CoffeePading.instance.high,
              child: SizedBox(
                width: size.width * 0.55,
                height: size.height * 0.25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(flex: 3, child: _coffeNameText(context)),
                    Expanded(flex: 3, child: _questionText(context)),
                    Expanded(flex: 2, child: _noThanksButton()),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Hero _coffeNameText(BuildContext context) {
    return Hero(
        tag: "name${widget.coffee!.name!.toString()}", //CoffeNameTag
        child: Text(
          widget.coffee!.name!,
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.right,
        ));
  }

  Text _questionText(BuildContext context) {
    return Text(
      TextConst.treatText,
      textAlign: TextAlign.right,
      style: Theme.of(context).textTheme.headline1!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: CoffeeColors.kTitleColor.withOpacity(0.5),
          ),
    );
  }

  Align _noThanksButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteConst.checkoutView,
              arguments: CheckoutView(
                coffee: widget.coffee,
              ));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: CoffeeColors.kTitleColor,
          padding: CoffeePading.instance.highHorizontalHighVertical,
          alignment: Alignment.centerLeft,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        child: Text(TextConst.noThanks),
      ),
    );
  }
}

_buildBackground() {
  return Column(
    children: [
      Expanded(
        flex: 1,
        child: BackgroundDecoration(
            end: Alignment.topLeft,
            begin: Alignment.bottomRight,
            stops: const [0.0, .50],
            colors: [CoffeeColors.kBrownColor.withOpacity(.7), CoffeeColors.kBrownColor.withOpacity(0.0)]),
      ),
      Expanded(
        flex: 1,
        child: BackgroundDecoration(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [0.0, .4],
            colors: [CoffeeColors.kBrownColor.withOpacity(.5), CoffeeColors.kBrownColor.withOpacity(0.0)]),
      ),
    ],
  );
}
