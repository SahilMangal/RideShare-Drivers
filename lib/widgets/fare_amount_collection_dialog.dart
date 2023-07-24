import 'package:flutter/material.dart';
import 'package:rideshare_driver/global/global.dart';
import 'package:flutter/services.dart';

class FareAmountCollectionDialog extends StatefulWidget {

  double? totalFareAmount;

  FareAmountCollectionDialog({this.totalFareAmount});

  @override
  State<FareAmountCollectionDialog> createState() => _FareAmountCollectionDialogState();
}

class _FareAmountCollectionDialogState extends State<FareAmountCollectionDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      //elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFF2D2727),
          border: Border.all(color: Color(0xFFff725e), width: 2),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFff725e),
              blurRadius: 4,
              offset: Offset(2, 2), // Shadow position
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 20,),

            Text(
              "Trip Fare Amount " + "(" + driverVehicleType!.toUpperCase() + ")",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Color(0xFFff725e),
                  fontFamily: "Ubuntu"
              ),
            ),

            const SizedBox(height: 20,),

            const Divider(
              height: 2,
              thickness: 2,
              color: Color(0xFFff725e),
            ),

            const SizedBox(height: 20,),

            Text(
               "\$" + widget.totalFareAmount.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Color(0xFFff725e),
                  fontFamily: "Ubuntu"
              ),
            ),

            const SizedBox(height: 10,),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "This is the total trip amount, Please collect from user.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Ubuntu"
                ),
              ),
            ),

            const SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFff725e),
                ),
                onPressed: (){
                  Future.delayed(const Duration(milliseconds: 2000), (){
                    SystemNavigator.pop();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Collect Cash",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Ubuntu"
                      ),
                    ),
                    Icon(
                      Icons.attach_money,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 5,),

          ],
        ),
      ),
    );
  }
}
