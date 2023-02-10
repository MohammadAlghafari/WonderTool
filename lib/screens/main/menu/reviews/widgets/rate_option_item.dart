import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/models/rate_option.dart';
import 'package:wonder_tool/themes/colors.dart';

class RateOptionItemWidget extends StatelessWidget {
  final RateOptionModel rateOption;
  final List<RateOptionModel> rateOptionsData;
  final bool isCompleted;
  final bool isAdded;

  const RateOptionItemWidget({
    Key? key,
    required this.rateOption,
    required this.rateOptionsData,
    required this.isCompleted,
    required this.isAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _rateValue = rateOption.value.obs;

    void changeValue(String id, double value) {
      final r = rateOptionsData.firstWhereOrNull((r) => r.id == id);
      if (r != null) {
        r.value = value;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            rateOption.title.toUpperCase(),
            style: TextStyle(
              color: isCompleted ? primaryColor : grayColor,
              fontSize: 15,
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 5),
          Column(
            children: [
              Obx(
                () => Slider(
                  value: _rateValue.value,
                  max: 5,
                  min: 0,
                  divisions: 5,
                  inactiveColor: grayColor,
                  activeColor: blueColor,
                  thumbColor: isCompleted ? primaryColor : grayColor,
                  label: _rateValue.round().toString(),
                  onChanged: (value) {
                    if (!isCompleted) {
                      return;
                    }

                    _rateValue.value = value;
                    changeValue(rateOption.id, value);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  AutoSizeText(
                    '0',
                    style: TextStyle(
                      color: grayColor,
                      fontSize: 12,
                    ),
                  ),
                  AutoSizeText(
                    '5',
                    style: TextStyle(
                      color: grayColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
